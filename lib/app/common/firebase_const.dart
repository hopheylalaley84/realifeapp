import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

final Future<FirebaseApp> initializationFirebase = Firebase.initializeApp();
FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
FirebaseAuth authInstance = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

String avatarUrl = 'https://firebasestorage.googleapis.com/v0/b/realife-c83b1.appspot.com/o/user.png?alt=media&token=d46a5ad9-0306-462d-b03a-5629e32ac4ac';

