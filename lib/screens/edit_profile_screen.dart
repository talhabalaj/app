import 'dart:io';

import 'package:Moody/components/loader.dart';
import 'package:Moody/components/primary_button.dart';
import 'package:Moody/constants.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/screens/edit_image_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/user_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthService authService;
  bool isProfilePicChanging = false;
  bool isUpdateLoading = false;
  String bio;
  String firstName;
  String lastName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Consumer<AuthService>(
          builder: (context, authService, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: ExtendedNetworkImageProvider(
                      authService.user.profilePicUrl,
                      cache: true,
                    ),
                    backgroundColor: kPrimaryColor,
                    child: isProfilePicChanging
                        ? Loader(
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    child: Text(
                      'Change profile picture',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    onTap: () async {
                      final image = File((await ImagePicker()
                              .getImage(source: ImageSource.gallery))
                          .path);
                      if (image != null) {
                        final imageEdited = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditImageScreen(image: image),
                          ),
                        );

                        this.setState(() {
                          isProfilePicChanging = true;
                        });

                        try {
                          await Provider.of<UserService>(context, listen: false)
                              .updateProfilePic(imageEdited);
                        } on WebErrorResponse catch (e) {
                          Toast.show(e.message, context);
                        }

                        this.setState(() {
                          isProfilePicChanging = false;
                        });
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('First Name'),
                    Container(
                      width: 200,
                      height: 20,
                      child: TextFormField(
                        initialValue: authService.user.firstName,
                        onChanged: (value) {
                          firstName = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Last Name'),
                    Container(
                      width: 200,
                      height: 20,
                      child: TextFormField(
                        initialValue: authService.user.lastName,
                        onChanged: (value) {
                          lastName = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Bio'),
                    Container(
                      width: 200,
                      height: 20,
                      child: TextFormField(
                        initialValue: authService.user.bio,
                        onChanged: (value) {
                          bio = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  child: Text("Update"),
                  loading: isUpdateLoading,
                  onPressed: () async {
                    this.setState(() {
                      isUpdateLoading = true;
                    });
                    try {
                      await Provider.of<UserService>(context, listen: false)
                          .updateUserInfo(
                        bio: bio,
                        firstName: firstName,
                        lastName: lastName,
                      );
                    } on WebErrorResponse catch (e) {
                      Toast.show(e.message, context);
                    }
                    this.setState(() {
                      isUpdateLoading = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
