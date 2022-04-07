// import 'dart:io';
// import 'package:chat/chat.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:squadchat/data/services/image_uploader_service.dart';

// import 'package:squadchat/cache/local_cache_contract.dart';
// import 'package:squadchat/states/status/status_state.dart';

// class StatusCubit extends Cubit<UploadingImageState> {
//   final IUserStatusService _userStatusService;
//   final ImageUploaderService _imageUploaderService;
//   final ILocalCache _localCache;

//   StatusCubit(this._userStatusService, this._imageUploaderService, this._localCache)
//       : super(StatusInitial());
 
//   Future<void> send(String name, File statusImage) async {
//     emit(Uploading());
//     final statusUrl = await _imageUploaderService.uploadImage(statusImage);
//     final userStatus = UserStatus(
//       userId: userId,
//       name: name,
//       statusUrl: statusUrl,
//       time: DateTime.now(),
//     ); 

//     final createdUserStatus = await _userStatusService.send(userStatus);
//     final userJson = {
//       'userId':createdUserStatus.userId,
//       'name': createdUserStatus.name,
//       'statusUrl': createdUserStatus.statusUrl,
//       'id': createdUserStatus.id
//     };

//     await _localCache.save('USER', userJson);
//     emit(UploadSuccess(createdUserStatus));
//   }
// }
