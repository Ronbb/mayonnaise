part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class StoreInitialize extends StoreEvent {}

class StoreInstanceCreate extends StoreEvent {
  const StoreInstanceCreate();

  @override
  List<Object?> get props => [];
}

class StoreClear extends StoreEvent {}
