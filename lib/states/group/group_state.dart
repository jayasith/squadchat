part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  factory GroupState.initial() => GroupInitial();

  factory GroupState.created(GroupMessage group) => GroupCreatedSuccess(group);

  factory GroupState.received(GroupMessage group) =>
      GroupReceivedSuccess(group);

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupCreatedSuccess extends GroupState {
  const GroupCreatedSuccess(this.group);

  final GroupMessage group;

  @override
  List<Object> get props => [group];
}

class GroupReceivedSuccess extends GroupState {
  const GroupReceivedSuccess(this.group);

  final GroupMessage group;

  @override
  List<Object> get props => [group];
}
