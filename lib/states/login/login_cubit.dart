import 'dart:io';
import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadchat/data/services/image_uploader_service.dart';
import 'package:squadchat/states/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IUserService _userService;
  final ImageUploaderService _imageUploader;

  LoginCubit(this._userService, this._imageUploader) : super(LoginInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploader.uploadImage(profileImage);
    final user = User(
      username: name,
      photoUrl: url,
      active: true,
      lastseen: DateTime.now(),
    );
    final createdUser = await _userService.connect(user);
    emit(LoginSuccess(createdUser));
  }
}
