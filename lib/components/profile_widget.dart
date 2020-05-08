import 'package:Moody/models/user_model.dart';
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    Text(
                      user.followingCount.toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'following',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    Text(
                      user.followerCount.toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'followers',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
