class WebErrorResponse {
  String type;
  int code;
  int status;
  String message;

  WebErrorResponse({this.type, this.code, this.status, this.message});

  WebErrorResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    code = json['code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
