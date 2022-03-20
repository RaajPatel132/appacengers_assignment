import 'package:book_store/models/book.dart';
import 'package:book_store/screens/book_details_screen.dart';
import 'package:book_store/screens/cart_route.dart';
import 'package:book_store/screens/liked_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provides/books_data_provider.dart';

//SCREEN THAT SHOWS ALL THE BOOKS AVAILABLE

class BookRoute extends StatelessWidget {
  const BookRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //GETTING ALL BOOKS FROM PROVIDER
    List<Book> allBooks =
        Provider.of<BooksProvider>(context, listen: true).getProviderBookList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartRoute(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LikedRoute(),
                  ),
                );
              },
              icon: const Icon(Icons.bookmark_outline)),
        ],
      ),
      body: ListView.builder(
        itemCount: allBooks.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == allBooks.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Provider.of<BooksProvider>(context, listen: false)
                        .loadFurther();
                  },
                  child: const Text('Load more')),
            );
          } else {
            return bookWidget(
                allBooks[index].id,
                allBooks[index].title,
                allBooks[index].authors,
                allBooks[index].download_count,
                allBooks[index].bookshelves,
                context);
          }
        },
      ),
    );
  }

  Widget bookWidget(int id, String title, String authors, int download_count,
      String bookshelves, context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailRoute(bookId: id),
          ),
        );
      },
      title: Text(title),
      subtitle: Text('by $authors from $bookshelves'),
      trailing: Column(
        children: [
          const Icon(Icons.download_outlined),
          Text(download_count.toString()),
        ],
      ),
    );
  }
}
