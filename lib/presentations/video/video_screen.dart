import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/presentations/video/components/example_actions_widget.dart';
import 'package:chat_app/presentations/video/video_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});
  final VideoController _con = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExampleActionsWidget(
        displayContentBuilder: (context, isLayoutHorizontal) {
          return Stack(
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.of(_con.remoteUid.map(
                      (e) => SizedBox(
                        width: 120,
                        height: 120,
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
          );
        },
        actionsBuilder: (context, isLayoutHorizontal) {
          final channelProfileType = [
            ChannelProfileType.channelProfileLiveBroadcasting,
            ChannelProfileType.channelProfileCommunication,
          ];
          final items = channelProfileType
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.toString().split('.')[1],
                    ),
                  ))
              .toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS))
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Flutter texture: '),
                            Switch(
                              value: _con.isUseFlutterTexture.value,
                              onChanged: _con.isJoined.value
                                  ? null
                                  : (changed) {
                                      _con.isUseFlutterTexture.value = changed;
                                    },
                            )
                          ]),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              const Text('Channel Profile: '),
              DropdownButton<ChannelProfileType>(
                items: items,
                value: _con.channelProfileType,
                onChanged: _con.isJoined.value
                    ? null
                    : (v) {
                        _con.channelProfileType = v!;
                      },
              ),
              const SizedBox(height: 20),
              // BasicVideoConfigurationWidget(
              //   rtcEngine: _con.engine,
              //   title: 'Video Encoder Configuration',
              //   setConfigButtonText: const Text(
              //     'setVideoEncoderConfiguration',
              //     style: TextStyle(fontSize: 10),
              //   ),
              //   onConfigChanged: (width, height, frameRate, bitrate) {
              //     _con.engine
              //         .setVideoEncoderConfiguration(VideoEncoderConfiguration(
              //       dimensions: VideoDimensions(width: width, height: height),
              //       frameRate: frameRate,
              //       bitrate: bitrate,
              //     ));
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _con.isJoined.value
                          ? _con.leaveChannel
                          : _con.joinChannel,
                      child: Text(
                          '${_con.isJoined.value ? 'Leave' : 'Join'} channel'),
                    ),
                  )
                ],
              ),
            ],
          );
        },
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
