import 'package:book_store/provides/books_data_provider.dart';
import 'package:book_store/provides/user_data_provider.dart';
import 'package:book_store/screens/splash_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
This is main file
/models - contains model classes to load data and serialise it according to need
/providers - contains some providers which will help in state management of app
/screens - contains all the possible routes of application
/widgets - contains some common widgets that are used repetitively
*/


//ENTRY POINT
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        //ACCOUNT DATA PROVIDER DECLARATION
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        //BOOK DETAIL DATA PROVIDER
        ChangeNotifierProvider(create: (context) => BooksProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color.fromRGBO(36, 48, 93, 1.0),
      ),
      //CALLING THE SPLASH SCREEN FIRST
      home: const SplashRoute()
    );
  }
}
