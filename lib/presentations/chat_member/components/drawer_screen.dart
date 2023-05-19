import 'package:chat_app/presentations/chat_member/chat_member_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  final ChatMemberController _con = Get.put(ChatMemberController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 15),
          Text(
            _con.userName.value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            _con.email.value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 30),
          const Divider(height: 2),
          ListTile(
            onTap: () => Get.back(),
            selectedColor: AppColors.accentColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            LocalStorage.logout();
                            Get.offAllNamed(AppRoutes.loginScreen);
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
