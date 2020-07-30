import 'package:cloud_firestore/cloud_firestore.dart';
// MODELLO PER UN GRUPPO
class OurGroup {
  String id;
  String name;
  String leader;
  List<String> members;
  Timestamp groupCreated;

  OurGroup({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
  });
}
