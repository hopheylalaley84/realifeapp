import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realifeapp/activities/views/widgets/user_widget.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/chat/screens/all_chats_screen.dart';

class Activities extends StatelessWidget {
  const Activities({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const CommonTextWidget(
          text: 'ACTIVITIES',
          size: 15,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const AllChatScreen());
            },
            icon: const Icon(Icons.email),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Column(
              children: [
                const CommonTextWidget(text: 'NEW',size: 15,),
                Expanded(
                  child: ListView(
                    children: snapshot.data.docs
                        .map<Widget>(
                          (val) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          color: const Color(0xff242529),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserActivWidget(
                              userId: val['ownerId'],
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        }
      ),
    );
  }
}
