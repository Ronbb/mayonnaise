import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mayonnaise/blocs/instance/instance_bloc.dart';
import 'package:mayonnaise/models/store.dart';
import 'package:uuid/uuid.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitializing()) {
    add(StoreInitialize());
  }

  Box<InstanceInfo>? _box;
  List<InstanceBloc>? instances;

  Box<InstanceInfo>? get box => _box;

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is StoreInitialize) {
      yield* _init(event);
      return;
    }
    if (event is StoreInstanceCreate) {
      if (_box != null && instances != null) {
        final String id = Uuid().v4();
        await _box!.put(id, InstanceInfo(id: id, name: 'New Instance'));
        instances!.add(InstanceBloc(id, store: this));
        yield StoreReady(instances: instances!);
      }
      return;
    }
    if (event is StoreClear) {
      _box!.clear();
      instances!.clear();
      yield StoreReady(instances: instances!);
    }
  }

  Stream<StoreState> _init(StoreInitialize event) async* {
    yield StoreInitializing(hint: 'opening database');
    final box = await Hive.openBox<InstanceInfo>('store');
    _box = box;
    instances = box.values
        .map(
          (item) => InstanceBloc(item.id, store: this),
        )
        .toList();
    yield StoreReady(instances: instances!);
  }
}
