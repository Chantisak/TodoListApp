
import 'package:flutter/material.dart';
import 'package:todo_list/src/services/local_storage_service.dart';
import 'package:todo_list/src/views/home.dart';
import 'package:todo_list/src/views/login.dart';

import 'configs/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme(context),
      home: _buildPage(),
    );
  }

  FutureBuilder<String> _buildPage() => FutureBuilder<String>(
      future: LocalStorageService().getToken(),
      builder: (context, snapshot) {
        final token = snapshot.data;
       
        if (token == null || token.isEmpty) {
          return Login();
        }
        return Home();
      });
}
