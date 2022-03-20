import 'dart:async';
import 'dart:convert';

import 'package:book_store/models/book.dart';
import 'package:book_store/provides/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BooksProvider with ChangeNotifier {

  //DECLARING REQUIRED FIELDS
  List<Book> bookList = List.empty(growable: true);
  List<Book> cartList = List.empty(growable: true);
  List<Book> likedList = List.empty(growable: true);
  String nextLink = "null";
  bool dataLoaded = false;

  //GETTER FOR BOOK LIST
  List<Book> getProviderBookList() {
    if (!dataLoaded) {
      loadBookList();
    }
    return bookList;
  }

  //GETTER FOR CART LIST
  List<Book> getProviderCartList(context) {
    loadCartBooks(context);
    return cartList;
  }

  //GETTER FOR LIKED BOOKS
  List<Book> getProviderLikedList(context) {
    loadCartBooks(context);
    return likedList;
  }

  //LOADING BOOKS-GENERAL
  Future<void> loadBookList() async {
    var url = Uri.parse('http://skunkworks.ignitesol.com:8000/books');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print('Something went wrong01');
    } else {
      Map<String, dynamic> map = jsonDecode(response.body);
      List x = map['results'];
      nextLink = map['next'];
      bookList.clear();
      dataLoaded = true;
      for (var i in x) {
        bookList.add(Book.fromMap(i));
      }
    }
    notifyListeners();
  }

  //LOAD MORE BOOKS AT THE END OF SCROLLING
  Future<void> loadFurther() async {
    if (!dataLoaded) {
      loadBookList();
    }
    var url = Uri.parse(nextLink);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Something went wrong04');
      }
    } else {
      Map<String, dynamic> map = jsonDecode(response.body);
      List x = map['results'];
      nextLink = map['next'];
      for (var i in x) {
        bookList.add(Book.fromMap(i));
      }
    }
    notifyListeners();
  }

  //GET ONLY TOP X BOOKS FROM THE LIST
  List getFirstXList(int count) {
    if (!dataLoaded) {
      loadBookList();
    }
    return bookList.sublist(0, count);
  }

  Future<void> loadCartBooks(context) async {
    if (!dataLoaded) {
      loadBookList();
    }
    String? cart =
        Provider.of<AccountProvider>(context, listen: true).userModel.cartBooks;
    if (cart == '') {
      return;
    }

    cart = cart?.trim().replaceAll("&", ",");
    String urlCart = 'http://skunkworks.ignitesol.com:8000/books/?ids=$cart';
    var url = Uri.parse(urlCart);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print('Something went wrong02');
    } else {
      Map<String, dynamic> map = jsonDecode(response.body);
      List x = map['results'];
      cartList.clear();
      for (var i in x) {
        cartList.add(Book.fromMap(i));
      }
    }
    notifyListeners();
  }

  //GET LIKED BOOKS
  Future<void> loadLikedBooks(context) async {
    if (!dataLoaded) {
      loadBookList();
    }
    //GET LIKED sTRING FROM ACCOUNT PROVIDER
    String? liked = Provider.of<AccountProvider>(context, listen: true)
        .userModel
        .likedBooks;

    liked = liked?.trim().replaceAll("&", ",");
    String urlCart = 'http://skunkworks.ignitesol.com:8000/books/?ids=$liked';
    var url = Uri.parse(urlCart);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print('Something went wrong03');
    } else {
      Map<String, dynamic> map = jsonDecode(response.body);
      List x = map['results'];
      likedList.clear();
      for (var i in x) {
        likedList.add(Book.fromMap(i));
      }
    }
    notifyListeners();
  }
}
