class UserModel {
  String? userId;
  String? email;
  String? name;
  String? likedBooks;
  String? cartBooks;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.likedBooks,
    required this.cartBooks,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      likedBooks: map['likedBooks'],
      cartBooks: map['cartBooks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'likedBooks': likedBooks,
      'cartBooks': cartBooks,
    };
  }
}
