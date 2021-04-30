part of 'instance_bloc.dart';

abstract class InstanceState extends Equatable {
  const InstanceState();
  
  @override
  List<Object> get props => [];
}

class InstanceInitial extends InstanceState {}
