import 'package:Moody/components/default_shimmer.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/people_list_screen.dart';
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
          backgroundColor: Colors.grey[100],
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
                  gotoPageWithAnimation(
                    context: context,
                    page: PeopleListScreen(
                      listTitle: 'Following',
                      list: user.following.map((e) => e.sId).toList(),
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
                  gotoPageWithAnimation(
                    context: context,
                    page: PeopleListScreen(
                      listTitle: 'Followers',
                      list: user.followers.map((e) => e.sId).toList(),
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

class ProfilePlaceHolderWigdet extends StatelessWidget {
  const ProfilePlaceHolderWigdet({Key key}) : super(key: key);

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
          backgroundColor: Colors.grey[300],
        ),
        SizedBox(
          height: 10,
        ),
        DefaultShimmer(
          height: 20,
          width: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DefaultShimmer(
            width: 100,
            height: 13,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: null,
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    DefaultShimmer(
                      height: 25,
                      width: 25,
                    ),
                    Text(
                      'following',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: null,
                disabledTextColor: Colors.grey[600],
                child: Column(
                  children: <Widget>[
                    DefaultShimmer(
                      height: 25,
                      width: 25,
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
