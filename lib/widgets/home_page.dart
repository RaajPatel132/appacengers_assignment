import 'package:book_store/screens/book_details_screen.dart';
import 'package:book_store/screens/book_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provides/books_data_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //LOADING 15 BOOKS TO SHOW AT HOME PAGE
    List homeBooks = Provider.of<BooksProvider>(context, listen: false)
        .getProviderBookList()
        .take(15)
        .toList();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Top picks for you',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              for (var i in homeBooks)
                bookHomeCard(i.id, i.title, "", i.authors, context),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookRoute(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        Text(
                          "View More",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Text(homeBooks[0].toString()),
          // const Padding(
          //   padding: EdgeInsets.all(8),
          //   child: Text(
          //     'Categories',
          //     style: TextStyle(
          //       fontSize: 20,
          //       color: Colors.black87,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Wrap(
          //     direction: Axis.horizontal,
          //     children: [
          //       for (var i in categories)
          //         SizedBox(
          //           width: (MediaQuery.of(context).size.width - 16) / 2,
          //           child: Card(
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8.0),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Center(
          //                   child: Text(
          //                 i.label,
          //                 style: const TextStyle(
          //                   fontSize: 16,
          //                   color: Colors.black87,
          //                 ),
          //               )),
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bookHomeCard(bookId, label, image, authors, context) {
    //WIDGET TO DISPLAY NAME AND AUTHOR OF BOOK
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailRoute(bookId: bookId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                'by $authors',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CategoryItem {
//   String label;
//   IconData iconData;
//
//   CategoryItem(this.label, this.iconData);
// }
