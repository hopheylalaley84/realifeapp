import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realifeapp/app/common/firebase_const.dart';


class Post {
  String id;
  String type;
  Timestamp createDate;
  String ownerId;
  String text;
  String videoUrl;
  String thumbnail;
  List tags;
  String category;
  bool active;
  String songName;
  bool fake;
  String thumbnailPath;

  Post({
    this.id,
    this.type,
    this.createDate,
    this.ownerId,
    this.text,
    this.videoUrl,
    this.thumbnail,
    this.tags,
    this.category,
    this.active,
    this.songName,
    this.fake,
    this.thumbnailPath
  });

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "type": type,
        "createDate": createDate,
        "ownerId": ownerId,
        "text": text,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "tags": tags,
        "category": category,
        "active": active,
        "songName": songName,
        "fake": fake,
      };


  factory Post.fromFireStore(DocumentSnapshot doc){
    dynamic snapshot = doc.data();

    return Post(
        id: snapshot['id'],
        type: snapshot['type'],
        createDate: snapshot['createDate'],
        ownerId: snapshot['ownerId'],
        text: snapshot['text'],
        videoUrl: snapshot['videoUrl'],
        thumbnail: snapshot['thumbnail'],
        tags: snapshot['tags'],
        category: snapshot['category'],
        active: snapshot['active'],
        songName: snapshot['songName'],
        fake: snapshot['fake'],
        thumbnailPath:snapshot['thumbnailPath']

    );
  }


// static Post fromSnap(DocumentSnapshot snap) {
//   var snapshot = snap.data() as Map<String, dynamic>;
//
//   return Post(
//     id: snapshot['id'],
//     type: snapshot['type'],
//     createDate: snapshot['createDate'],
//     ownerId: snapshot['ownerId'],
//     text: snapshot['text'],
//     videoUrl: snapshot['videoUrl'],
//     thumbnail: snapshot['thumbnail'],
//     tags: snapshot['tags'],
//     category: snapshot['category'],
//     active: snapshot['active'],
//     songName: snapshot['songName'],
//     fake: snapshot['fake'],
//   );
// }
}