class User {
  String userName;
  String id;
  String name;
  String email;

  User({this.id, this.userName, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    userName = json["userName"];
    id = json["_id"];
    name = json["name"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['_id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}
