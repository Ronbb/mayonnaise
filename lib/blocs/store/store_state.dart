part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitializing extends StoreState {
  const StoreInitializing({this.hint});

  final String? hint;

  @override
  List<Object?> get props => [hint];
}

class StoreReady extends StoreState {
  StoreReady({required List<InstanceBloc> instances}) {
    this.instances = [...instances];
  }

  late final List<InstanceBloc> instances;

  @override
  List<Object?> get props => [instances];
}
