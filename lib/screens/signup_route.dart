import 'package:book_store/screens/home_route.dart';
import 'package:book_store/screens/login_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({Key? key}) : super(key: key);

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final _formKey = GlobalKey<FormState>();

  //EDITING CONTROLLERS

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //NAME
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.text,
      onSaved: (value) => nameController.text = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Name");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_box_outlined),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //EMAIL
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => emailController.text = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //PASSWORD
    final passwordField = TextFormField(
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      autofocus: false,
      controller: passwordController,
      onSaved: (value) => passwordController.text = value!,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //CONFIRM PASSWORD
    final conPasswordField = TextFormField(
      validator: (value) {
        if (passwordController.text != conPasswordController.text) {
          return ("Passwords didn't match");
        }
        return null;
      },
      autofocus: false,
      controller: conPasswordController,
      onSaved: (value) => passwordController.text = value!,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //BUTTON SUBMIT
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          signUp(nameController.text, emailController.text,
              passwordController.text);
        },
        child: const Text("Sign Up",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        color: Colors.blueGrey,
      ),
    );

    //GOTO BACK LOGIN
    final gotoLogIn = Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LogInRoute()));
          },
          child: const Text("Log In"),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 40, top: 5),
                            color: Colors.blueGrey,
                            height: 2,
                            width: MediaQuery.of(context).size.width / 3),
                        nameField,
                        const SizedBox(height: 14),
                        emailField,
                        const SizedBox(height: 14),
                        passwordField,
                        const SizedBox(height: 14),
                        conPasswordField,
                        const SizedBox(height: 14),
                        loginButton,
                        const SizedBox(height: 14),
                        gotoLogIn,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void signUp(String name, String email, String password) async {
    //CREATING USER IN FIREBASE
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  void postDetailsToFirestore() async {
    //AFTER SUCCESSFUL USER CREATION ADDING USER DETAILS TO FIRESTORE
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(
        name: nameController.text,
        likedBooks: '',
        cartBooks: '',
        userId: user?.uid,
        email: user!.email);

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeRoute()));
  }
}
