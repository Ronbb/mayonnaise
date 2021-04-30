import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'instance_event.dart';
part 'instance_state.dart';

class InstanceBloc extends Bloc<InstanceEvent, InstanceState> {
  InstanceBloc() : super(InstanceInitial());

  @override
  Stream<InstanceState> mapEventToState(
    InstanceEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
