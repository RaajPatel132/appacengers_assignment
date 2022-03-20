import 'package:book_store/models/book.dart';
import 'package:book_store/provides/user_data_provider.dart';
import 'package:book_store/screens/cart_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provides/books_data_provider.dart';
import 'book_details_screen.dart';

class LikedRoute extends StatelessWidget {
  const LikedRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> likedBooks = Provider.of<BooksProvider>(context, listen: true)
        .getProviderLikedList(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Books'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<AccountProvider>(context, listen: false)
                    .addToCart(1661);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartRoute(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      body: ListView.builder(
        itemCount: likedBooks.length,
        itemBuilder: (BuildContext context, int index) {
          return bookWidget(likedBooks[index], context);
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, Book book) {
    // set up the buttons
    Widget updateButton = TextButton(
      child: const Text("View Book", style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetailRoute(bookId: book.id)));
      },
    );
    Widget deleteButton = TextButton(
      child: const Text("Remove", style: TextStyle(color: Colors.red)),
      onPressed: () {
        Provider.of<AccountProvider>(context, listen: false)
            .removeFromLiked(book.id);
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.black45)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(book.title),
      content: const Text("What do you want to do with this item"),
      actions: [updateButton, deleteButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget bookWidget(book, context) {
    return ListTile(
      onTap: () {
        showAlertDialog(context, book);
      },
      title: Text(book.title),
      subtitle: Text('by ${book.authors} from ${book.bookshelves}'),
      trailing: Column(
        children: [
          const Icon(Icons.download_outlined),
          Text(book.download_count.toString()),
        ],
      ),
    );
  }
}
