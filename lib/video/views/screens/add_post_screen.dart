import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:realifeapp/app/common/components/common_text_widget.dart';
import 'package:realifeapp/app/common/firebase_const.dart';
import 'package:realifeapp/video/controllers/video_controller.dart';
import 'package:sizer/sizer.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final VideoController videoController = Get.put(VideoController());
  String formatDate(DateTime date) =>  DateFormat("MMMM d yyyy").format(date);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonTextWidget(
          text: 'NEW PUBLICATION',
          size: 15,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(videoController.videoFile.value != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CommonTextWidget(
                      text: 'VIDEO UPLOADED',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      size: 20,)),
                  ),
                if(videoController.videoFile.value == null)
                  Container(
                    color: const Color(0xff242529),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            GestureDetector(
                              onTap: () {
                                videoController.pickVideo(
                                    ImageSource.gallery, context);
                              },
                              child: DottedBorder(
                                color: Colors.grey[300],
                                //color of dotted/dash line
                                strokeWidth: 1,
                                //thickness of dash/dots
                                dashPattern: const [10, 6],
                                //dash patterns, 10 is dash width, 6 is space width
                                child: SizedBox(
                                  height: 160,
                                  width: 40.w,
                                  child:  Image.asset('assets/images/ph.png'),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                videoController.pickVideo(
                                    ImageSource.camera, context);
                              },
                              child: DottedBorder(
                                color: Colors.grey[300],
                                //color of dotted/dash line
                                strokeWidth: 1,
                                //thickness of dash/dots
                                dashPattern: const [10, 6],
                                child: SizedBox(
                                  height: 160,
                                  width: 40.w,
                                  child:  Image.asset('assets/images/vi.png'),
                                ),
                              ),
                            ),
                          ],
                        )

                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextWidget(
                  text: 'Description',
                  size: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Text'
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  minLines: 5,
                  onChanged: (val) {
                    videoController.descriptionPost.value = val;
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextWidget(
                  text: 'Tag',
                  size: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: videoController.tagList
                            .map(
                              (element) =>
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff737476),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(
                                          child: CommonTextWidget(
                                            text: element,
                                            size: 12,
                                            color: Colors.grey[300],
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    left: 65,
                                    child: GestureDetector(
                                      onTap: () {
                                        videoController.tagList.remove(element);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        )
                            .toList(),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: videoController.tagListBase
                      .map((element) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            videoController.tagList.add(element);
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: const BoxDecoration(
                                color: Color(0xff242529),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            child: Center(
                                child: CommonTextWidget(
                                  text: element,
                                  size: 12,
                                  color: Colors.grey[300],
                                )),
                          ),
                        ),
                      ))
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return DropdownButtonFormField(
                    hint: const Text(
                      'Choose category',
                      style: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      videoController.categorySelect.value = value;
                    },
                    items: videoController.dropMenuList
                        .map(
                          (e) =>
                          DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: Color(0xff36313C),
                              ),
                            ),
                          ),
                    )
                        .toList(),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                CommonTextWidget(
                  text: '@User',
                  size: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: firestore.collection('users').doc(authInstance.currentUser.uid).get(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return TextFormField(
                        decoration: InputDecoration(
                            hintText: snapshot.data['name'].toString().capitalizeFirst
                        ),
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                    return Container();
                  }
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,color: Colors.white,),
                    const SizedBox(width: 8,),
                    CommonTextWidget(
                      text: formatDate(DateTime.now()),
                      size: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 50,
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: videoController.loadingVideo.value == true
                            ? null
                            : () {
                          videoController.uploadVideo(
                              videoController.videoPath.value);
                        },
                        child: videoController.loadingVideo.value == true
                            ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                            : const CommonTextWidget(
                          text: 'PUBLISH',
                          size: 14,
                        ),
                      );
                    }),
                  ),
                ),

              ],
            );
          }),
        ),
      ),
    );
  }
}
