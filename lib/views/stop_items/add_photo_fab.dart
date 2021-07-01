import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../common/badge_icon.dart';

typedef PhotoUploadedHandler = void Function(String url);

class AddPhotoFab extends HookWidget {
  final Function onPressed;
  final int countImages;
  final bool isProcess;

  const AddPhotoFab({
    this.onPressed,
    this.countImages = 0,
    this.isProcess = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'photo_float_btn',
      onPressed: !isProcess ? onPressed : null,
      child: isProcess
          ? CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
          : BadgeIcon(
              icon: Icon(Icons.photo),
              badgeCount: countImages,
            ),
    );
  }
}
