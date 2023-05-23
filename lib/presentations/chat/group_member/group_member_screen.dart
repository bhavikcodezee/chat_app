import 'package:chat_app/presentations/chat/group_member/group_member_controller.dart';
import 'package:chat_app/presentations/contact/components/contact_tile.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({super.key});
  final GroupMemberController _con = Get.put(GroupMemberController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        title: const Text(
          "Participants",
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () => Get.toNamed(AppRoutes.contactScreen),
        //     icon: const Icon(
        //       Icons.add,
        //       color: AppColors.whiteColor,
        //     ),
        //   ),
        // ],
        backgroundColor: AppColors.accentColor,
      ),
      body: Obx(
        () => _con.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : _con.contactList.isEmpty
                ? const Center(child: Text("No contact found"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    itemCount: _con.contactList.length,
                    itemBuilder: (context, index) {
                      return ContactTile(
                        contactModel: _con.contactList[index],
                        isAdmin: _con.contactList[index].uid ==
                            _con.contactModel?.uid,
                        isGroup: false.obs,
                        isSelected: RxBool(false),
                        onChanged: (v) {},
                      );
                    },
                  ),
      ),
    );
  }
}
