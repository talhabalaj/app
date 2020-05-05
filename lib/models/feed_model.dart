import 'package:app/models/post_model.dart';

class FeedModel {
  List<PostModel> posts;

  FeedModel() : posts = List<PostModel>();

  FeedModel.fromJson(List<dynamic> json) {
    posts = new List<PostModel>();
    json.forEach((v) {
      posts.add(new PostModel.fromJson(v));
    });
  }

  List<dynamic> toJson() {
    final List<dynamic> data = new List<dynamic>();
    if (this.posts != null) {
      this.posts.forEach((value) {
        data.add(value);
      });
    }
    return data;
  }
}
