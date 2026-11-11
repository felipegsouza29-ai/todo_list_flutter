import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/app.storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Appstorage().ensureDefaulUser();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        onLogin: (){
          
        },
      ),
    ),
  );
}