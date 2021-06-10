part of 'instance_bloc.dart';

abstract class InstanceState extends Equatable {
  const InstanceState();

  @override
  List<Object?> get props => [];
}

class InstanceInitializing extends InstanceState {
  const InstanceInitializing({this.hint});

  final String? hint;

  @override
  List<Object?> get props => [hint];
}

class InstanceReady extends InstanceState {}

class InstanceConnecting extends InstanceState {}

class InstanceConnected extends InstanceState {
  const InstanceConnected(this.instance);

  final WebSocketChannel instance;

  @override
  List<Object?> get props => [instance];
}

class InstanceClosed extends InstanceState {
  const InstanceClosed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
