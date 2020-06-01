import 'package:Moody/components/default_shimmer.dart';
import 'package:Moody/components/loader.dart';
import 'package:Moody/components/primary_button.dart';
import 'package:Moody/components/profile_widget.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/edit_profile_screen.dart';
import 'package:Moody/screens/login_screen.dart';
import 'package:Moody/screens/post_screen.dart';
import 'package:Moody/services/user_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserService _userService;
  UserModel _user;

  bool _userProfileLoading = true;
  bool _postsLoading = true;

  bool _actionLoading = false;

  bool _isFollowing = false;
  bool _isCurrentUser = false;

  List<PostModel> _userPosts;
  int _lastIndexFetched;

  @override
  void didChangeDependencies() {
    _userService = Provider.of<UserService>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await getProfile();
        _isFollowing = _userService.loggedInUser.isFollowing(_user);
        _isCurrentUser = _userService.loggedInUser.sId == _user.sId;
        List<PostModel> posts = await getUserPosts();
        if (this.mounted)
          this.setState(() {
            _userPosts = posts;
            _postsLoading = false;
            _lastIndexFetched = 0;
          });
      } on WebErrorResponse catch (e) {
        Toast.show(e.message, context);
      }
    });

    super.didChangeDependencies();
  }

  Future<List<PostModel>> getUserPosts({int offset = 0}) async {
    if (_isCurrentUser)
      return this._userService.getUserPosts(offset: offset);
    else
      return this
          ._userService
          .getUserPosts(id: widget.user.sId, offset: offset);
  }

  Future<void> getProfile() async {
    if (widget.user != null)
      _user = await _userService.getUserProfile(widget.user.sId);
    else
      _user = _userService.loggedInUser;

    if (this.mounted)
      this.setState(() {
        _userProfileLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.user != null
              ? widget.user.userName
              : (_user != null ? _user.userName : 'Loading'),
        ),
        actions: <Widget>[
          if (_isCurrentUser)
            IconButton(
              icon: Icon(EvaIcons.logOutOutline),
              onPressed: () async {
                try {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.id, (Route<dynamic> route) => false);
                  await _userService.authService.logout();
                } on WebErrorResponse catch (e) {
                  Toast.show(e.message, context);
                }
              },
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_isCurrentUser) {
            await _userService.authService.refreshUser();
          } else {
            await getProfile();
          }
        },
        child: CustomScrollView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate: _buildUserProfile(context),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            _postsLoading
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          DefaultShimmer(margin: EdgeInsets.zero),
                      childCount: 9,
                    ),
                  )
                : _userPosts.length > 0
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          _buildUserPosts,
                          childCount: _userPosts.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1 / 1,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                      )
                    : Center(
                        child: Text(
                          "No posts to show.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
            if (_postsLoading)
              SliverToBoxAdapter(
                child: Loader(),
              ),
          ],
        ),
      ),
    );
  }

  SliverChildListDelegate _buildUserProfile(BuildContext context) {
    return SliverChildListDelegate.fixed(
      _userProfileLoading
          ? [ProfilePlaceHolderWigdet()]
          : [
              ProfileWidget(user: _user),
              Center(
                child: _isCurrentUser
                    ? PrimaryButton(
                        onPressed: () {
                          gotoPageWithAnimation(
                            context: context,
                            page: EditProfileScreen(),
                          );
                        },
                        child: Text('Edit Profile'),
                      )
                    : PrimaryButton(
                        child: _isFollowing ? Text('Unfollow') : Text('Follow'),
                        onPressed: _actionLoading ? null : _handleChangeFollow,
                      ),
              ),
            ],
    );
  }

  Widget _buildUserPosts(context, index) {
    if (index < _userPosts.length) {
      return GestureDetector(
        onTap: () {
          gotoPageWithAnimation(
            context: context,
            page: PostScreen(
              post: _userPosts[index],
            ),
          );
        },
        child: ExtendedImage.network(
          _userPosts[index].imageUrl,
          cache: true,
        ),
      );
    } else {
      if (_lastIndexFetched < index) {
        _lastIndexFetched = index;

        getUserPosts(offset: _userPosts.length).then((value) {
          if (this.mounted)
            this.setState(() {
              _userPosts.addAll(value);
              _postsLoading = false;
            });
        });
      }
      return null;
    }
  }

  _handleChangeFollow() async {
    this.setState(() {
      _actionLoading = true;
    });
    if (_isFollowing) {
      await _userService.changeFollowState(_user,
          action: UserFollowAction.UNFOLLOW);
    } else {
      await _userService.changeFollowState(_user);
    }
    this.setState(() {
      _actionLoading = false;
    });
  }
}
