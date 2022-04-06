import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class UploadingImageState extends Equatable {}

class StatusInitial extends UploadingImageState {
  @override
  List<Object> get props => [];
}

class Uploading extends UploadingImageState {
  @override
  List<Object> get props => [];
}

class UploadSuccess extends UploadingImageState {
  final UserStatus userStatus;

  UploadSuccess(this.userStatus);

  @override
  List<Object> get props => [userStatus];
}
