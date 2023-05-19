import 'package:chat_app/presentations/auth/verification/verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key});
  final VerificationController _con = Get.put(VerificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter the OTP sent to your phone',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PinFieldAutoFill(
              codeLength: 6,
              onCodeChanged: (p0) {},
              onCodeSubmitted: (String code) {
                _con.verifyOTP(code);
              },
            ),
          ),
        ],
      ),
    );
  }
}
