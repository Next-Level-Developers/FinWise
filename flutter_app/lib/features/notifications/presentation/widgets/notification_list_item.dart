import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => ListTile(title: Text(title));
}
