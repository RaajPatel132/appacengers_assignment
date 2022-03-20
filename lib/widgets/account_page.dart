import 'package:book_store/screens/liked_route.dart';
import 'package:book_store/screens/login_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/cart_route.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //GETTING CURRENT USER
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
              color: Theme.of(context).primaryColor,
              child: const Text(
                'Account',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 39,
                ),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              //READING STREAM OF DATA TO LISTEN TO REALTIME UPDATES WITH STREAM BUILDER
                stream: FirebaseFirestore.instance
                    .collection("users") //.add(category.toMap());

                    .where('userId', isEqualTo: user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 40),
                      child: LinearProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          snapshot.data?.docs[0]['name'],
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          snapshot.data?.docs[0]['email'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        OutlineButton.icon(
                            onPressed: () {
                              //LOGGING OUT USER
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LogInRoute()));
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('LogOut')),
                      ],
                    );
                  }
                }),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 10,
                thickness: 2,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LikedRoute()));
                },
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Liked Books",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Click here to see watch your liked books",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 10,
                thickness: 2,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartRoute()));
                },
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Cart",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Click here to see books you added to your cart",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 10,
                thickness: 2,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    color: Theme.of(context).primaryColor,
                    child: const Text(
                      "Book",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2),
                    child: Text(
                      "Store",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'v0.0.1',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
