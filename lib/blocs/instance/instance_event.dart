part of 'instance_bloc.dart';

abstract class InstanceEvent extends Equatable {
  const InstanceEvent();

  @override
  List<Object> get props => [];
}

class InstanceWebSocketConnect extends InstanceEvent {
  const InstanceWebSocketConnect();

  @override
  List<Object> get props => [];
}
