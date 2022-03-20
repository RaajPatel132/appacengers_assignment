class Book {
  final int id;
  final String authors;
  final String bookshelves;
  final int download_count;
  final String languages;
  final String media_type;
  final String title;
  final String image;

  Book({
    required this.id,
    required this.authors,
    required this.bookshelves,
    required this.download_count,
    required this.languages,
    required this.media_type,
    required this.title,
    required this.image,
  });

  factory Book.fromMap(map) {
    return Book(
        id: map['id'],
        authors: (map['authors'] as List).isEmpty
            ? 'Null'
            : map['authors'][0]['name'],
        bookshelves: (map['bookshelves'] as List).isEmpty
            ? 'The Library'
            : map['bookshelves'][0],
        download_count: map['download_count'],
        languages:
            (map['languages'] as List).isEmpty ? 'en' : map['languages'][0],
        media_type: map['media_type'],
        title: map['title'],
        image: (map['formats'] as Map).containsKey('image/jpeg')
            ? map['formats']['image/jpeg']
            : "https://www.claws.in/static/book-cover-placeholder-e1563706855534.jpg");
  }
}
