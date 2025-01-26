
// lib/widgets/image_picker_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:retali/utils/image_picker_util.dart';



class ImagePickerBottomSheet extends StatelessWidget {
  final Function(File?) onImagePicked;

  const ImagePickerBottomSheet({
    Key? key,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Ambil Foto'),
            onTap: () async {
              Navigator.pop(context);
              final image = await ImagePickerUtil.pickImage(
                source: ImageSource.camera,
                maxWidth: 1024,
                quality: 70,
              );
              onImagePicked(image);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Pilih dari Galeri'),
            onTap: () async {
              Navigator.pop(context);
              final image = await ImagePickerUtil.pickImage(
                source: ImageSource.gallery,
                maxWidth: 1024,
                quality: 70,
              );
              onImagePicked(image);
            },
          ),
        ],
      ),
    );
  }
}
