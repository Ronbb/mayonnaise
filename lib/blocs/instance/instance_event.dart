part of 'instance_bloc.dart';

abstract class InstanceEvent extends Equatable {
  const InstanceEvent();

  @override
  List<Object?> get props => [];
}

class InstanceInitialize extends InstanceEvent {}

class InstanceWebSocketConnect extends InstanceEvent {
  const InstanceWebSocketConnect(this.url);

  final String url;

  @override
  List<Object?> get props => [this.url];
}

class InstanceWebSocketDisconnect extends InstanceEvent {
  const InstanceWebSocketDisconnect(this.code, this.message);

  final int code;

  final String message;

  @override
  List<Object?> get props => [this.code, this.message];
}

class InstanceWebSocketError extends InstanceEvent {
  const InstanceWebSocketError(this.error);

  final Error error;

  @override
  List<Object?> get props => [this.error];
}

class InstanceDatabaseReset extends InstanceEvent {}

class InstanceMessageSend extends InstanceEvent {
  const InstanceMessageSend(this.message);

  final String message;

  @override
  List<Object?> get props => [this.message];
}
