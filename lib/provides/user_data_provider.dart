import 'package:book_store/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AccountProvider with ChangeNotifier {
  late UserModel userModel;
  bool dataLoaded = false;

  //FIRESTORE INSTANCE
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  //METHOD TO LOAD ALL ACC DATA
  Future<String> loadAccData() async {
    dataLoaded = true;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value);
    });

    notifyListeners();
    return "done";
  }

  checkDataLoaded(){
    if(!dataLoaded){
      loadAccData();
    }
  }

  //ADD TO CART
  Future<void> addToCart(int bookId) async {
    if (!dataLoaded) {
      loadAccData();
    }
    //CART FORMAT - ID1&ID2&ID3  -- BOOK IDS SEPARATED BY &
    userModel.cartBooks =
        userModel.cartBooks!.isEmpty || userModel.cartBooks!.trim() == ""
            ? bookId.toString()
            : userModel.cartBooks! + '&' + bookId.toString();
    await firebaseFirestore
        .collection("users")
        .doc(firebaseUser?.uid)
        .update({"cartBooks": userModel.cartBooks});
    notifyListeners();
  }

  Future<void> addToLiked(int bookId) async {
    if (!dataLoaded) {
      loadAccData();
    }
    userModel.likedBooks =
        userModel.likedBooks!.isEmpty || userModel.likedBooks!.trim() == ""
            ? bookId.toString()
            : userModel.likedBooks! + '&' + bookId.toString();

    await firebaseFirestore
        .collection("users")
        .doc(firebaseUser?.uid)
        .update({"likedBooks": userModel.likedBooks});
    notifyListeners();
  }

  Future<void> removeFromCart(int bookId) async {
    if (!dataLoaded) {
      loadAccData();
    }
    if (userModel.cartBooks!.contains('&$bookId')) {
      userModel.cartBooks = userModel.cartBooks!.replaceAll("&$bookId", "");
    } else if (userModel.cartBooks!.contains('$bookId&')) {
      userModel.cartBooks = userModel.cartBooks!.replaceAll("$bookId&", "");
    } else {
      userModel.cartBooks = userModel.cartBooks!.replaceAll("$bookId", "");
    }
    await firebaseFirestore
        .collection("users")
        .doc(firebaseUser?.uid)
        .update({"cartBooks": userModel.cartBooks});
    notifyListeners();
  }

  Future<void> removeFromLiked(int bookId) async {
    if (!dataLoaded) {
      loadAccData();
    }
    if (userModel.likedBooks!.contains('&$bookId')) {
      userModel.likedBooks = userModel.likedBooks!.replaceAll("&$bookId", "");
    } else if (userModel.likedBooks!.contains('$bookId&')) {
      userModel.likedBooks = userModel.likedBooks!.replaceAll("$bookId&", "");
    } else {
      userModel.likedBooks = userModel.likedBooks!.replaceAll("$bookId", "");
    }
    await firebaseFirestore
        .collection("users")
        .doc(firebaseUser?.uid)
        .update({"likedBooks": userModel.likedBooks});
    notifyListeners();
  }
}
