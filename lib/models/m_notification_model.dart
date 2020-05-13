class M_Notification {
  bool read;
  String sId;
  String user;
  String message;
  String createdAt;
  String updatedAt;

  M_Notification({
    this.read,
    this.sId,
    this.user,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  M_Notification.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    sId = json['_id'];
    user = json['user'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['read'] = this.read;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
