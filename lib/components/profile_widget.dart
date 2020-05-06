import 'package:app/models/user_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final UserModel user;

  const ProfileWidget({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 20,
        ),
        CircleAvatar(
          radius: 50,
          backgroundImage: ExtendedNetworkImageProvider(
            user.profilePicUrl,
            cache: true,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            user.bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
              color: Colors.grey[600],
            ),
          ),
        ),
        RaisedButton(
          child: Text('Edit profile'),
          onPressed: () {},
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              ExtendedImage.network(user.profilePicUrl),
              ExtendedImage.network(user.profilePicUrl),
            ],
          ),
        )
      ],
    );
  }
}
