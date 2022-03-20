import 'dart:async';

import 'package:book_store/provides/user_data_provider.dart';
import 'package:book_store/screens/home_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provides/books_data_provider.dart';
import 'login_route.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({Key? key}) : super(key: key);

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    super.initState();

    //GETTING FIREBASE INSTANCE FOR LOGIN SIGN UP
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    //SENDING USER TO HOME PAGE AUR LOGIN PAGE ACCORDING TO CURRENT STATE
    Widget i = user == null ? const LogInRoute() : const HomeRoute();
    //PROVIDER TO LOAD DATA FIRST
    Provider.of<AccountProvider>(context, listen: false).loadAccData();
    Provider.of<BooksProvider>(context, listen: false).loadBookList();
    Timer(
      //WAITING 2 SEC AT LOGO
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => i)));
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Text(
          "Book Store",
          style: TextStyle(color: Colors.white70, fontSize: 30),
        ),
      ),
    );
  }
}
