import 'package:cloud_firestore/cloud_firestore.dart';

class CommentLike {
  String id;
  Timestamp createDate;
  String fromWho;
  String toWho;
  String postId;
  bool active;

  CommentLike({
    this.id,
    this.createDate,
    this.fromWho,
    this.toWho,
    this.postId,
    this.active,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "createDate": createDate,
    "fromWho": fromWho,
    "toWho": toWho,
    "postId": postId,
    "active": active,
  };

  static CommentLike fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentLike(
      id: snapshot['id'],
      createDate: snapshot['createDate'],
      fromWho: snapshot['fromWho'],
      toWho: snapshot['toWho'],
      postId: snapshot['postId'],
      active: snapshot['active'],
    );
  }
}