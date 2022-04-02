import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  Timestamp createDate;
  String avatar;
  String ownerId;
  String ownerName;
  String postId;
  String text;
  List<String> comments;

  Comment({
    this.id,
    this.createDate,
    this.avatar,
    this.ownerId,
    this.ownerName,
    this.postId,
    this.text,
    this.comments
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'createDate': createDate,
    'avatar': avatar,
    'ownerId': ownerId,
    'ownerName': ownerName,
    'postId': postId,
    'text': text,
    'comments' : comments
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      id: snapshot['id'],
      createDate: snapshot['createDate'],
      avatar: snapshot['avatar'],
      ownerId: snapshot['ownerId'],
      ownerName: snapshot['ownerName'],
      postId: snapshot['postId'],
      text: snapshot['text'],
      comments: snapshot['comments']
    );
  }
}