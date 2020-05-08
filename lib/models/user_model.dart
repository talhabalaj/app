class UserModel {
  String bio;
  List<UserModel> followers;
  List<UserModel> following;
  int followerCount;
  int followingCount;
  String profilePicUrl;
  String sId;
  String userName;
  String firstName;
  String lastName;

  UserModel(
      {this.bio,
      this.followers,
      this.following,
      this.followerCount,
      this.followingCount,
      this.profilePicUrl,
      this.sId,
      this.userName,
      this.firstName,
      this.lastName});

  UserModel.fromJson(Map<String, dynamic> json) {
    bio = json['bio'];
    if (json['followers'] != null) {
      followers = new List<UserModel>();
      json['followers'].forEach((v) {
        followers.add(new UserModel.fromJson(v));
      });
    }
    if (json['following'] != null) {
      following = new List<UserModel>();
      json['following'].forEach((v) {
        following.add(new UserModel.fromJson(v));
      });
    }
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    profilePicUrl = json['profilePicUrl'];
    sId = json['_id'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bio'] = this.bio;
    if (this.followers != null) {
      data['followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    if (this.following != null) {
      data['following'] = this.following.map((v) => v.toJson()).toList();
    }
    data['followerCount'] = this.followerCount;
    data['followingCount'] = this.followingCount;
    data['profilePicUrl'] = this.profilePicUrl;
    data['_id'] = this.sId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }

  bool isFollowing(UserModel user) {
    for (UserModel u in following) {
      if (user.sId == u.sId) {
        return true;
      }
    }

    return false;
  }

  bool isFollower(UserModel user) {
    for (UserModel u in followers) {
      if (user.sId == u.sId) {
        return true;
      }
    }

    return false;
  }
}
