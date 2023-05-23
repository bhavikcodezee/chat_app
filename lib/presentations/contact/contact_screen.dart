import 'package:chat_app/presentations/contact/components/contact_tile.dart';
import 'package:chat_app/presentations/contact/contact_controller.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});
  final ContactController _con = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.accentColor,
        title: const Text(
          "Contact",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => _con.isGroup.value
                ? IconButton(
                    onPressed: () {
                      _con.selectedContactList.clear();
                      _con.isGroup.value = false;
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.whiteColor,
                    ),
                  )
                : IconButton(
                    onPressed: () => _con.isGroup.value = true,
                    icon: const Icon(
                      Icons.group_add,
                      color: AppColors.whiteColor,
                    ),
                  ),
          )
        ],
      ),
      bottomSheet: Obx(
        () => _con.isGroup.value && _con.selectedContactList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: AppButton(
                  onPressed: () => createGroupDialog(context),
                  text: "Create",
                  isLoading: _con.isLoading,
                ),
              )
            : const SizedBox(),
      ),
      body: contactList(),
    );
  }

  Future<void> createGroupDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Create Group",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                )
              ],
            ),
            content: TextField(
              onChanged: (val) => _con.groupName.value = val,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Name",
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.accentColor),
                      borderRadius: BorderRadius.circular(10)),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.accentColor),
                      borderRadius: BorderRadius.circular(10))),
            ),
            actions: [
              AppButton(
                onPressed: () => _con.createGroup(context),
                text: "Create",
                isLoading: _con.isCreateGroup,
              ),
            ],
          );
        });
  }

  Widget contactList() {
    return Obx(
      () => _con.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _con.contactList.isEmpty
              ? const Center(child: Text("No contact found"))
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemCount: _con.contactList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => ContactTile(
                            contactModel: _con.contactList[index],
                            isGroup: _con.isGroup,
                            isAdmin: false,
                            isSelected: RxBool(
                              _con.selectedContactList
                                  .contains(_con.contactList[index].uid),
                            ),
                            onTap: () {
                              _con.createConversation(
                                  context, _con.contactList[index]);
                            },
                            onChanged: (v) =>
                                _con.onTap(_con.contactList[index].uid),
                          ),
                        );
                      },
                    ),
                    if (_con.isCreateConversation.value)
                      Container(
                        height: Get.height,
                        width: Get.width,
                        color: AppColors.accentColor.withOpacity(0.5),
                        child: const CircularProgressIndicator.adaptive(),
                      )
                  ],
                ),
    );
  }
}
