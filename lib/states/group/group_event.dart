part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  factory GroupEvent.onSubscribed(User user) => Subscribed(user);

  factory GroupEvent.onGroupCreated(GroupMessage group) => GroupCreated(group);

  @override
  List<Object> get props => [];
}

class Subscribed extends GroupEvent {
  final User user;

  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class GroupCreated extends GroupEvent {
  final GroupMessage group;

  const GroupCreated(this.group);

  @override
  List<Object> get props => [group];
}

class _GroupReceived extends GroupEvent {
  final GroupMessage group;

  const _GroupReceived(this.group);

  @override
  List<Object> get props => [group];
}
