import 'package:Moody/components/primary_button.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthService authService;

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
      body: Consumer<AuthService>(
        builder: (context, authService, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: CircleAvatar(),
              ),
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
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              PrimaryButton(
                child: Text("Update"),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
