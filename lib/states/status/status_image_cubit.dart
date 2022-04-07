import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class StatusImageCubit extends Cubit<File> {
  final _picker = ImagePicker();

  StatusImageCubit() : super(null);

  Future<void> getStatusImage() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return;

    emit(File(image.path));
  }
}