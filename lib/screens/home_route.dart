import 'package:book_store/provides/user_data_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/account_page.dart';
import '../widgets/home_page.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  //BOTTOM NAVIGATION BAR CURRENT PAGE
  late int _currentMenu;

  @override
  void initState() {
    _currentMenu = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AccountProvider>(context, listen: true).checkDataLoaded();
    return Scaffold(
      appBar: AppBar(title: const Text("Book Store")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentMenu,
        onTap: (newValue) {
          setState(() {
            _currentMenu = newValue;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: 'Account'),
        ],
      ),
      body: _currentMenu == 0 ? const HomePage() : const AccountPage(),
    );
  }
}
