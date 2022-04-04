import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class Loading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}
