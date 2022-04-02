import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/discover/views/widgets/user_widget.dart';
import 'package:realifeapp/profile/user_screen/user_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';


  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanDown,
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search,color: Colors.grey,)
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() {
                      search = val;
                    });
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                ),
              ),
              StreamBuilder(
                  stream: search.isEmpty ? firestore.collection('posts').snapshots() : firestore.collection('posts')
                  .where("searchName", arrayContains: search)
                  .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map<Widget>(
                                (val) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(() => UserScreen(userId:val['ownerId'],));
                                    },
                                    child: UserWidget(
                                      userId: val['ownerId'],
                                      posts: snapshot.data.docs.toList(),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
