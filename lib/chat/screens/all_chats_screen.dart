import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/chat/screens/chat_screen.dart';
import 'package:realifeapp/chat/widgets/msgWidget.dart';

class AllChatScreen extends StatelessWidget {
  const AllChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonTextWidget(
          text: 'DIRECT MESSAGES',
          size: 12,
        ),
      ),
      body: StreamBuilder(
          stream: firestore.collection('msg').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List chats = snapshot.data.docs;
              List chats2 = chats
                  .where((element) =>
                      element['fromWho'] == authInstance.currentUser.uid ||
                      element['toWho'] == authInstance.currentUser.uid)
                  .toList();
              return SingleChildScrollView(
                child: Column(
                  children: chats2
                      .map<Widget>(
                        (item) => GestureDetector(
                          onTap: () {
                            Get.to(
                              ChatScreen(
                                chatId: item['id'],
                                userId: item['fromWho'],
                                senderId: item['toWho'],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: const Color(0xff242529),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: MsgWidget(
                                  usrId: item['toWho'],
                                  senderId: item['fromWho'],
                                ),
                              ),
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
    );
  }
}
