import 'dart:io';
import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/data/services/image_uploader_service.dart';
import 'package:squadchat/states/login/login_state.dart';
import 'package:squadchat/cache/local_cache_contract.dart';

class LoginCubit extends Cubit<LoginState> {
  final IUserService _userService;
  final ImageUploaderService _imageUploaderService;
  final ILocalCache _localCache;

  LoginCubit(this._userService, this._imageUploaderService,this._localCache)
      : super(LoginInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploaderService.uploadImage(profileImage);
    final user = User(
      username: name,
      photoUrl: url,
      active: true,
      lastseen: DateTime.now(),
    );
    final createdUser = await _userService.connect(user);
    final userJson ={
      'username' : createdUser.username,
      'active'    : true,
      'photo_url' : createdUser.photoUrl,
      'id'        : createdUser.id 
    }
    await _localCache.save('USER',userJson);
    emit(LoginSuccess(createdUser));
  }
}
