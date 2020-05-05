import 'dart:io';

import 'package:app/models/create_post_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_editor/image_editor.dart';

class CreatePostScreen extends StatefulWidget {
  static String id = '/createCreatePost';

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    final File args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
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

              final controller = TextEditingController();
              await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text("Add Caption"),
                  children: <Widget>[
                    TextField(
                      controller: controller,
                    ),
                    FlatButton(
                      child: Text("Done"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              final image = await FlutterImageCompress.compressWithList(
                  result.toList(),
                  format: CompressFormat.jpeg);
              String caption = controller.text;
              Navigator.pop<CreatePostModel>(
                  context, CreatePostModel(image, caption));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: ExtendedImage.file(
          args,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            return EditorConfig(
                maxScale: 8.0,
                cropRectPadding: EdgeInsets.all(20.0),
                hitTestSize: 20.0,
                cropAspectRatio: CropAspectRatios.ratio1_1);
          },
        ),
      ),
    );
  }
}
