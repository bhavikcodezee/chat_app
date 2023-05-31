import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/presentations/video/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});
  final VideoController _con = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _con.engine,
              canvas: const VideoCanvas(uid: 0),
              useFlutterTexture: _con.isUseFlutterTexture.value,
              useAndroidSurfaceView: _con.isUseAndroidSurfaceView.value,
            ),
            onAgoraVideoViewCreated: (viewId) {
              _con.engine.startPreview();
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Obx(
              () => Row(
                children: List.of(_con.remoteUid.map(
                  (e) => Container(
                    width: 120,
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _con.engine,
                        canvas: VideoCanvas(uid: e),
                        connection:
                            RtcConnection(channelId: _con.channelId.value),
                        useFlutterTexture: _con.isUseFlutterTexture.value,
                        useAndroidSurfaceView:
                            _con.isUseAndroidSurfaceView.value,
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
          toolbar(context)
        ],
      ),
    );
  }

  Widget toolbar(context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: _con.onToggleMute,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: _con.isMuted.value ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _con.isMuted.value ? Icons.mic_off : Icons.mic,
                color: _con.isMuted.value ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: () => _con.onCallEnd(context),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _con.switchCameraFn,
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
