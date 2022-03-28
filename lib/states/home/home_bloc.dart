import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  IUserService _userService;

  HomeBloc(this._userService) : super(HomeInitial());

  // Future<User> connect() async {
  //   final userJson = _localCache.fetch('USER');
  //   userJson['last_seen'] = DateTime.now();
  //   userJson['active'] = true;
  //
  //   final user = User.fromJson(userJson);
  //   await _userService.connect(user);
  //   return user;
  // }

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
