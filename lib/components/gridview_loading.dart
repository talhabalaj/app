import 'package:Moody/components/default_shimmer.dart';
import 'package:flutter/material.dart';

class GridViewLoading extends StatelessWidget {
  const GridViewLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1 / 1,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        for (int i = 0; i < 9; i++) DefaultShimmer(),
      ],
    );
  }
}
