
import 'package:flutter/material.dart';

class NoFollowersWidget extends StatelessWidget {
  const NoFollowersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return const Center(
        child: Text("No Followers", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
      );

  }
}
