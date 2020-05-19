import 'package:Moody/components/loader.dart';
import 'package:Moody/components/post_widget.dart';
import 'package:Moody/components/primary_button.dart';
import 'package:Moody/components/profile_widget.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  ProfileScreen({@required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  bool actionLoading = false;
  UserService userService;
  UserModel user;
  bool isFollowing = false;
  bool isCurrentUser = false;

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context);
    getProfile();
    super.didChangeDependencies();
  }

  Future<void> getProfile() async {
    user = await userService.getUserProfile(widget.user.sId);
    if (this.mounted)
      this.setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      isFollowing = userService.loggedInUser.isFollowing(user);
      isCurrentUser = userService.loggedInUser.sId == user.sId;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.user.userName,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
      body: loading
          ? ProfilePlaceHolderWigdet()
          : RefreshIndicator(
              onRefresh: () async {
                await getProfile();
              },
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  ProfileWidget(user: user),
                  if (!isCurrentUser)
                    Center(
                      child: PrimaryButton(
                        child: isFollowing ? Text('Unfollow') : Text('Follow'),
                        onPressed: actionLoading
                            ? null
                            : () async {
                                this.setState(() {
                                  actionLoading = true;
                                });
                                if (isFollowing) {
                                  await userService.changeFollowState(user,
                                      action: UserFollowAction.UNFOLLOW);
                                } else {
                                  await userService.changeFollowState(user);
                                }
                                this.setState(() {
                                  actionLoading = false;
                                });
                              },
                      ),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  UserPosts(user: user)
                ],
              ),
            ),
    );
  }
}
