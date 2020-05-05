class UserModel {
  String profilePicUrl;
  String sId;
  String userName;
  String firstName;
  String lastName;

  UserModel(
      {this.profilePicUrl,
      this.sId,
      this.userName,
      this.firstName,
      this.lastName});

  UserModel.fromJson(Map<String, dynamic> json) {
    profilePicUrl = json['profilePicUrl'];
    sId = json['_id'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilePicUrl'] = this.profilePicUrl;
    data['_id'] = this.sId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
