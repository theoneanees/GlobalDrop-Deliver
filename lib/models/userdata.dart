import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  final String? email;
  final String? username;
  final String? photoUrl;

  UserData({
    required this.id,
    required this.email,
    this.username,
    this.photoUrl,
  });

  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      id: json['uid'].toString().trim(),
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'uid': id.toString().trim(),
      'photoUrl': photoUrl,
    };
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      // id: (doc.data()as dynamic)['doc'],
      // email: (doc.data()as dynamic)['email'],
      // username: (doc.data()as dynamic)['username'],
      // photoUrl: (doc.data()as dynamic)['photoUrl']

      id: doc.data().toString().contains('id') ? doc.get('id') : '',
      email: doc.data().toString().contains('email') ? doc.get('email') : '',
      username:
          doc.data().toString().contains('username') ? doc.get('username') : '',
      photoUrl:
          doc.data().toString().contains('photoUrl') ? doc.get('photoUrl') : '',
    );
  }
}
