// image_picker_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:retali/utils/image_picker_util.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function(File?) onImagePicked;
  final ThemeData theme;
  const ImagePickerBottomSheet({
    Key? key,
    required this.onImagePicked,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: theme.primaryColor),
            title: Text(
              'Ambil Foto',
              style: theme.textTheme.bodyMedium,
            ),
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
            leading: Icon(Icons.photo_library, color: theme.primaryColor),
            title: Text(
              'Pilih dari Galeri',
              style: theme.textTheme.bodyMedium,
            ),
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