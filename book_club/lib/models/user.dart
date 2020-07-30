import 'package:cloud_firestore/cloud_firestore.dart';

// USER MODEL!

class OurUser {
  String uid;
  String email;
  String fullName;
  Timestamp accountCreated; // Timestamp da cloud_firestore!
  String groupId;

  OurUser({
    this.uid,
    this.email,
    this.fullName,
    this.accountCreated,
    this.groupId,
  });
}
