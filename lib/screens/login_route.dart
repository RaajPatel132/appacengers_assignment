import 'package:book_store/screens/home_route.dart';
import 'package:book_store/screens/signup_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogInRoute extends StatefulWidget {
  const LogInRoute({Key? key}) : super(key: key);

  @override
  State<LogInRoute> createState() => _LogInRouteState();
}

class _LogInRouteState extends State<LogInRoute> {
  final _formKey = GlobalKey<FormState>();

  //EDITING CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //EMAIL FIELD
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

    //PASSWORD FIELD
    final passwordField = TextFormField(
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
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
          signIn(emailController.text, passwordController.text);
        },
        child: const Text("Log In", style: TextStyle(color: Colors.white)),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        color: Colors.blueGrey,
      ),
    );

    //BUTTON GOTO SIGNUP
    final gotoSignUp = Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpRoute()));
          },
          child: const Text("Sign Up"),
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
                              "Log In",
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
                          emailField,
                          const SizedBox(height: 14),
                          passwordField,
                          const SizedBox(height: 14),
                          loginButton,
                          const SizedBox(height: 14),
                          gotoSignUp,
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  //sign in with email password
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                setState(() {
                  _isLoading = false;
                }),
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeRoute()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
