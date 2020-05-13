import 'package:Moody/components/primary_button.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/people_list_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

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
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.transferRight,
                      child: PeopleListScreen(
                        listTitle: 'Following',
                        list: user.following.map((e) => e.sId).toList(),
                      ),
                    ),
                  );
                },
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    Text(
                      user.following.length.toString(),
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
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.transferRight,
                      child: PeopleListScreen(
                        listTitle: 'Followers',
                        list: user.followers.map((e) => e.sId).toList(),
                      ),
                    ),
                  );
                },
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    Text(
                      user.followers.length.toString(),
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
