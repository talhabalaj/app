import 'package:Moody/components/default_shimmer.dart';
import 'package:flutter/material.dart';

class GridViewLoading extends StatelessWidget {
  const GridViewLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: <Widget>[
        for (int i = 0; i < 9; i++) DefaultShimmer(),
      ],
    );
  }
}
