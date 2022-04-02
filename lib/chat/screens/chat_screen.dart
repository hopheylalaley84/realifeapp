import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String senderId;


  const ChatScreen({Key key, this.chatId, this.userId,this.senderId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();

  XFile allImages1;
  String imgUrl;
  final ImagePicker _picker = ImagePicker();
  bool sendMsg = false;
  bool sendMsgImg = false;

  Future getImage(ImageSource imageSource) async {
    if (imageSource == ImageSource.camera) {
      XFile allImages;
      final XFile photo =
      await _picker.pickImage(source: ImageSource.camera).catchError((e) {
        print(e);
        setState(() {
          sendMsgImg = false;
        });
      });
      if (photo != null) {
        allImages1 = photo;
        return allImages = photo;
      }
    }
    if (imageSource == ImageSource.gallery) {
      final XFile photo =
      await _picker.pickImage(source: ImageSource.gallery).catchError((e) {
        setState(() {
          sendMsgImg = false;
        });
        print(e);
      });
      XFile allImages;
      if (photo != null) {
        allImages1 = photo;
        allImages = photo;
        return allImages = photo;
      }
    }
  }

  UploadTask uploadEachFile(String distination, XFile file) {
    try {
      final ref = FirebaseStorage.instance.ref(distination);
      return ref.putFile(File(file.path));
    } on FirebaseException catch (e) {
      Get.snackbar('Ошибка', 'Попробуйте позже ',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('000${e.code}');
      return null;
    }
  }

  uploadPhoto() async {
    setState(() {
      sendMsgImg = true;
    });
    final fileName = allImages1;
    final distination =
        'files/${authInstance.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}';
    UploadTask task = uploadEachFile(distination, fileName);
    if (task != null) {
      final snapshot = await task.whenComplete(() => {});
      imgUrl = await snapshot.ref.getDownloadURL();
      final ref = firestore
          .collection('msg')
          .doc(widget.chatId)
          .collection('chat');
      await ref.add({
        'createDate': Timestamp.now(),
        'id': ref.id,
        'message': imgUrl,
        'sender': authInstance.currentUser.uid,
      })
      .whenComplete(() => setState(() {
        sendMsgImg = false;
      }));
      print(imgUrl);
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: firestore.collection('users').doc(widget.senderId != authInstance.currentUser.uid ? widget.senderId : widget.userId).get(),
            builder: (context, snapshot) {
              if(snapshot.hasData){

                return Text(snapshot.data['name']);
              }
             return Container();
            }
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder(
                stream: firestore
                    .collection('msg')
                    .doc(widget.chatId)
                    .collection('chat')
                    .orderBy('createDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: snapshot.data.docs
                            .map<Widget>(
                              (val) => SizedBox(
                                width: 150,
                                child: Bubble(
                                  margin:
                                      const BubbleEdges.only(top: 10, left: 10),
                                  alignment: authInstance.currentUser.uid ==
                                          val['sender']
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  nip:authInstance.currentUser.uid ==
                                      val['sender'] ? BubbleNip.rightTop :  BubbleNip.leftTop,
                                  color: const Color.fromRGBO(212, 234, 244, 1.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      val['message'].length >= 23
                                          ? val['message'].substring(0, 23) ==
                                                  'https://firebasestorage'
                                              ? SizedBox(
                                                  height: 150,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: CachedNetworkImage(
                                                      imageUrl: val['message'],
                                                      placeholder:
                                                          (context, url) =>
                                                              const SizedBox(
                                                        height: 150,
                                                        width: 100,
                                                        child:
                                                            LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.grey,
                                                        ),
                                                      ),
                                                      errorWidget: (context, url,
                                                              error) =>
                                                          const Icon(Icons.error),
                                                    ),
                                                  ),
                                                )
                                              : Text(val['message'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15.0))
                                          : Text(val['message'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 15.0)),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          DateFormat('yyyy-MM-dd H:m')
                                              .format(val['createDate'].toDate()),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11.0)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            Container(
              color: const Color(0xff242529),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        allImages1 = null;
                        getImage(ImageSource.gallery)
                            .whenComplete(() => uploadPhoto());
                      },
                      icon: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(bottom: 8, left: 5),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      width: 68.w,
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final ref = firestore
                              .collection('msg')
                              .doc(widget.chatId)
                              .collection('chat');
                          await ref.add({
                            'createDate': Timestamp.now(),
                            'id': ref.id,
                            'message': message.text,
                            'sender': authInstance.currentUser.uid,
                          }).whenComplete(
                            () => message.clear(),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xff037FF3)),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          width: 50,
                          height: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
