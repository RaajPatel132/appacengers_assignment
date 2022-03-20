import 'package:book_store/models/book.dart';
import 'package:book_store/models/user.dart';
import 'package:book_store/provides/books_data_provider.dart';
import 'package:book_store/provides/user_data_provider.dart';
import 'package:book_store/screens/cart_route.dart';
import 'package:book_store/screens/liked_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailRoute extends StatelessWidget {
  const BookDetailRoute({Key? key, required this.bookId}) : super(key: key);
  final int bookId;

  @override
  Widget build(BuildContext context) {
    //GETTING REQUIRED BOOK FROM PROVIDER
    Book book = Provider.of<BooksProvider>(context, listen: true)
        .getProviderBookList()
        .where((element) => element.id == bookId)
        .toList()[0];
    UserModel userModel =
        Provider.of<AccountProvider>(context, listen: true).userModel;

    //CHECKING IF BOOKS ARE LIKED OR NOT
    bool isLiked = userModel.likedBooks!.contains(book.id.toString()),
        isCart = userModel.cartBooks!.contains(book.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Book ID : ${book.id.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Title : ${book.title}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const Divider(height: 10, thickness: 2),
              Text(
                'Authors : ${book.authors}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Bookshelves : ${book.bookshelves}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const Divider(height: 10, thickness: 2),
              Text(
                'Downloads : ${book.download_count.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Available in : ${book.languages}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const Divider(height: 10, thickness: 2),
              ElevatedButton(
                //PERFORMING ONCLICK ACCORDING TO IF PRODUCT IS ALREADY LIKED OR NOT
                  onPressed: () {
                    if (isCart) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartRoute(),
                        ),
                      );
                    } else {
                      Provider.of<AccountProvider>(context, listen: false)
                          .addToCart(bookId);
                    }
                  },
                  child: Text(isCart ? 'Go to Cart' : 'Add To Cart')),
              isCart
                  ? OutlinedButton(
                      onPressed: () {
                        Provider.of<AccountProvider>(context, listen: false)
                            .removeFromCart(bookId);
                      },
                      child: const Text('Remove from Cart'))
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () {
                  if (isLiked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LikedRoute(),
                      ),
                    );
                  } else {
                    Provider.of<AccountProvider>(context, listen: false)
                        .addToLiked(bookId);
                  }
                },
                child: Text(isLiked ? 'Go to Liked' : 'Like This book'),
              ),
              isLiked
                  ? OutlinedButton(
                      onPressed: () {
                        Provider.of<AccountProvider>(context, listen: false)
                            .removeFromLiked(bookId);
                      },
                      child: const Text('Remove from Liked'))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
