import 'package:flutter/material.dart';

class SharedContextMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (selected) => print("Feature not yet supported"),
        itemBuilder: (context) => [PopupMenuItem(child: Text("Manage data"))]);
  }
}
