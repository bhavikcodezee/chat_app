import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/presentations/pickup/pickup_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/check_network_connectivity.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PickUpScreen extends StatelessWidget {
  final bool isForOutGoing;
  PickUpScreen({super.key, required this.isForOutGoing});
  final PickUpcontroller _con = Get.put(PickUpcontroller());

  @override
  Widget build(BuildContext context) {
    _con.isForOutGoing.value = isForOutGoing;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.2, 0.6],
            colors: [
              AppColors.accentColor,
              AppColors.primaryColor.withOpacity(0.8)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isForOutGoing ? "Outgoing Call..." : "Incoming Call...",
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            _getImageUrlWidget(),
            const SizedBox(height: 30),
            Text(
              _con.contactModel?.fullName ?? "",
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _callingButtonWidget(context, false),
                isForOutGoing
                    ? _callingButtonWidget(context, true)
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //To Display Profile Image Of User
  _getImageUrlWidget() => ClipOval(
          child: CircleAvatar(
        backgroundColor: AppColors.whiteColor,
        radius: Get.width * 0.2,
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                ),
            errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
            imageUrl: _con.contactModel?.profilepic ?? ""),
      ));

  _callingButtonWidget(BuildContext context, bool isCall) => RawMaterialButton(
        onPressed: () {
          if (isCall) {
            _con.timer?.cancel();
            pickUpCallPressed(context);
          } else {
            _con.endCall();
          }
        },
        shape: const CircleBorder(),
        elevation: 2.0,
        fillColor: isCall ? Colors.green : Colors.redAccent,
        padding: const EdgeInsets.all(20),
        child: Icon(
          isCall ? Icons.call : Icons.call_end,
          color: Colors.white,
          size: 25,
        ),
      );

  void pickUpCallPressed(context) async {
    if (await Permission.camera.request().isGranted) {
      if (await Permission.microphone.request().isGranted) {
        FlutterRingtonePlayer.stop();
        if (await checkNetworkConnection(context)) {
          Get.offNamed(AppRoutes.videoScreen, arguments: _con.channelName);
        }
      }
    }
  }
}
