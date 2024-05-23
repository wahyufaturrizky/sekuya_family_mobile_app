import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class MyWidgetEmptyListApp extends StatelessWidget {
  const MyWidgetEmptyListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWidgetEmptyList();
  }
}

class MyWidgetEmptyList extends StatefulWidget {
  const MyWidgetEmptyList({super.key});

  @override
  State<MyWidgetEmptyList> createState() => _MyWidgetEmptyListState();
}

class _MyWidgetEmptyListState extends State<MyWidgetEmptyList> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/empty_state.png'),)
        ),
      )
    );
  }
}
