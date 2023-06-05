import 'package:chat_app/presentations/pickup/pickup_screen.dart';
import 'package:chat_app/routes/app_pages.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  LocalStorage.loadLocalData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.getPages,
      builder: LocalStorage.isLogin.value
          ? (context, child) {
              return StreamBuilder<QuerySnapshot<Object?>>(
                stream: DatabaseService().listenToInComingCall(),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      child ?? Container(),
                      if (snapshot.hasData &&
                          snapshot.data?.docs != null &&
                          snapshot.data!.docs.isNotEmpty)
                        PickUpScreen(
                          isForOutGoing: true,
                          docId: snapshot.data!.docs[0]['doc_id'],
                        )
                    ],
                  );
                },
              );
            }
          : null,
    );
  }
}
