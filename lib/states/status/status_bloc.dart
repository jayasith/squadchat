// import 'package:bloc/bloc.dart';
// import 'package:chat/chat.dart';
// import 'package:squadchat/cache/local_cache_contract.dart';
// import 'package:squadchat/states/status/status_state.dart';


// class HomeBloc extends Cubit<UploadingImageState> {
//   IUserStatusService _userStatusService;
//   ILocalCache _localCache;

//   HomeBloc(this._userStatusService, this._localCache) : super(StatusInitial());

//   Future<User> connect() async {
//     final userJson = _localCache.fetch('USER');
//     userJson['last_seen'] = DateTime.now();
//     userJson['active'] = true;

//     final userStatus = UserStatus.fromJson(userJson);
//     await _userStatusService.connect(user);
//     return user;
//   }

//   Future<void> activeUsers(User user) async {
//     emit(HomeLoading());
//     final users = await _userService.online();
//     users.removeWhere((element) => element.id == user.id);
//     emit(HomeSuccess(users));
//   }
// }
