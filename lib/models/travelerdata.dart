import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerData {
  final String id;
  final String? email;
  final String? username;
  final String? photoUrl;

  TravelerData({
    required this.id,
    required this.email,
    required this.username,
    required this.photoUrl,
  });

  factory TravelerData.fromDocument(DocumentSnapshot doc) {
    return TravelerData(
      // id: (doc.data()as dynamic)['doc'],
      // email: (doc.data()as dynamic)['email'],
      // username: (doc.data()as dynamic)['username'],
      // photoUrl: (doc.data()as dynamic)['photoUrl']

      id: doc.data().toString().contains('id') ? doc.get('id') : '',
      email: doc.data().toString().contains('email') ? doc.get('email') : '',
      username: doc.data().toString().contains('username') ? doc.get('username') : '',
      photoUrl: doc.data().toString().contains('photoUrl') ? doc.get('photoUrl') : '',

    );
  }
}