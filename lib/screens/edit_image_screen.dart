import 'dart:io';

import 'package:Moody/models/post_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_editor/image_editor.dart';
import 'package:provider/provider.dart';

class EditImageScreen extends StatefulWidget {
  final File image;

  EditImageScreen({this.image});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Image"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              final state = editorKey.currentState;
              final action = editorKey.currentState.editAction;
              final rect = editorKey.currentState.getCropRect();

              final rotateAngle = action.rotateAngle.toInt();
              final flipHorizontal = action.flipY;
              final flipVertical = action.flipX;
              final img = state.rawImageData;

              ImageEditorOption option = ImageEditorOption();

              if (action.needCrop) option.addOption(ClipOption.fromRect(rect));

              if (action.needFlip)
                option.addOption(
                  FlipOption(
                      horizontal: flipHorizontal, vertical: flipVertical),
                );

              if (action.hasRotateAngle)
                option.addOption(RotateOption(rotateAngle));

              var result = await ImageEditor.editImage(
                image: img,
                imageEditorOption: option,
              );

              final image = await FlutterImageCompress.compressWithList(
                  result.toList(),
                  format: CompressFormat.jpeg);

              Navigator.pop(context, image);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: ExtendedImage.file(
          widget.image,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: CropAspectRatios.ratio1_1,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 55,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.flip),
              onPressed: () {
                editorKey.currentState.flip();
              },
            ),
            IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () {
                editorKey.currentState.rotate(right: false);
              },
            ),
            IconButton(
              icon: Icon(Icons.rotate_right),
              onPressed: () {
                editorKey.currentState.rotate(right: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
