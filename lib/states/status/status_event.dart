part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();
  factory StatusEvent.onSubscribed(User user) => Subscribed(user);
  factory StatusEvent.onMessageSent(UserStatus userStatus) => StatusSent(userStatus);

  @override
  List<Object> get props => [];
}

class Subscribed extends StatusEvent {
  final User user;

  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class StatusSent extends StatusEvent {
  final UserStatus userStatus;

  const StatusSent(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}

class _StatusReceived extends StatusEvent {
  final UserStatus userStatus;

  const _StatusReceived(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}
