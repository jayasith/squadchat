part of 'status_bloc.dart';



abstract class StatusState extends Equatable {
  const StatusState();
  factory StatusState.initial() => StatusInitial();
  factory StatusState.sent(UserStatus userStatus) => StatusSentSuccess(userStatus);
  factory StatusState.received(UserStatus userStatus) =>
      StatustReceivedSuccess(userStatus);

  @override
  List<Object> get props => [];
}

class StatusInitial extends StatusState {}

class StatusSentSuccess extends StatusState {
  final UserStatus userStatus;
  const StatusSentSuccess(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}

class StatustReceivedSuccess extends StatusState {
  final UserStatus userStatus;
  const StatustReceivedSuccess(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}
