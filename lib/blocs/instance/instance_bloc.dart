import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mayonnaise/blocs/store/store_bloc.dart';
import 'package:mayonnaise/models/message.dart';
import 'package:mayonnaise/models/store.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'instance_event.dart';
part 'instance_state.dart';

class InstanceBloc extends Bloc<InstanceEvent, InstanceState> {
  InstanceBloc(String id, {required this.store})
      : _id = id,
        super(InstanceInitializing()) {
    this.add(InstanceInitialize());
  }

  final StoreBloc store;
  final String _id;
  LazyBox<Message>? _box;
  WebSocketChannel? _instance;

  InstanceInfo get info => store.box!.get(_id)!;

  String get url => info.url;
  set url(String url) {
    store.box!.put(_id, info.copyWith(url: url));
  }

  String get id => _id;
  String get name => info.name;
  LazyBox<Message>? get box => _box;

  @override
  Stream<InstanceState> mapEventToState(InstanceEvent event) async* {
    if (event is InstanceInitialize) {
      yield* _init(event);
      return;
    }
    if (event is InstanceWebSocketConnect) {
      url = event.url;
      yield* _createWebSocket();
      return;
    }
    if (event is InstanceWebSocketError) {
      yield InstanceClosed(event.error.toString());
      return;
    }
    if (event is InstanceWebSocketDisconnect) {
      yield InstanceClosed('${event.code}: ${event.message}');
      return;
    }
  }

  void _listen() {
    final instance = _instance;
    instance!.stream.listen(
      (event) {
        _box?.add(
          Message(
            time: DateTime.now(),
            message: event.toString(),
          ),
        );
      },
      onError: (error) {
        _box?.add(
          Message(
            time: DateTime.now(),
            message: error.toString(),
            type: MessageType.error,
          ),
        );
        add(InstanceWebSocketError(error));
      },
      onDone: () {
        _box?.add(
          Message(
            time: DateTime.now(),
            message: '${instance.closeCode}: ${instance.closeReason}',
            type: MessageType.done,
          ),
        );
        add(InstanceWebSocketDisconnect(
          instance.closeCode ?? -1,
          instance.closeReason ?? '',
        ));
      },
    );
  }

  Stream<InstanceState> _createWebSocket() async* {
    if (url.isNotEmpty) {
      yield InstanceConnecting();
      _instance?.sink.close();
      final instance = WebSocketChannel.connect(Uri.parse(url));
      _instance = instance;
      yield InstanceConnected(instance);
      _listen();
    }
  }

  Stream<InstanceState> _init(InstanceInitialize event) async* {
    yield InstanceInitializing(hint: 'opening database');
    _box = await Hive.openLazyBox<Message>('message:$_id');
    yield InstanceReady();
  }
}
