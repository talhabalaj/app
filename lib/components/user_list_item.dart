import 'package:Moody/components/default_shimmer.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/profile_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  const UserListItem(
      {Key key, @required this.user, this.chevron = true, this.onTap})
      : super(key: key);

  final bool chevron;
  final UserModel user;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final userExists = user != null;

    return FlatButton(
      onPressed: userExists
          ? () {
              if (onTap == null) {
                FocusScope.of(context).unfocus();
                gotoPageWithAnimation(
                    context: context,
                    page: ProfileScreen(user: user),
                    name: '/user/${user.sId}');
              } else {
                onTap();
              }
            }
          : null,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[300],
                backgroundImage: userExists
                    ? ExtendedNetworkImageProvider(user.profilePicUrl)
                    : null,
              ),
              SizedBox(
                width: 10,
              ),
              userExists
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.userName,
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DefaultShimmer(
                          height: 13,
                          width: 60,
                        ),
                        DefaultShimmer(
                          height: 14,
                          width: 70,
                        ),
                      ],
                    )
            ],
          ),
          if (chevron) Icon(EvaIcons.chevronRight),
        ],
      ),
    );
  }
}
