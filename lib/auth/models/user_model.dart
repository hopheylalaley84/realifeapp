import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  Timestamp createDate;
  String phone;
  String dateOfBirth;
  String avatar;
  String profileStatus;
  String location;
  DocumentSnapshot settings;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.createDate,
    this.phone,
    this.location,
    this.dateOfBirth,
    this.settings,
    this.avatar,
    this.profileStatus

  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    uid = snapshot.id;
    name = data['name'];
    email = data['email'];
    createDate = data['createDate'];
    phone = data['phone'];
    location = data['location'];
    dateOfBirth = data['dateOfBirth'];
    settings = data['settings'];
    avatar = data['avatar'];
    profileStatus = data['profileStatus'];
  }
}