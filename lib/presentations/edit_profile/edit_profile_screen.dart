import 'dart:io';

import 'package:chat_app/presentations/edit_profile/edit_profile_controller.dart';
import 'package:chat_app/widget/app_bar.dart';
import 'package:chat_app/widget/app_button.dart';
import 'package:chat_app/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController _con = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Edit Profile",
      ),
      body: Obx(
        () => _con.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.accentColor,
                  strokeWidth: 5,
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryColor,
                            child: _con.url.isEmpty
                                ? _con.selectedProfile.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: AppColors.whiteColor,
                                        size: 50,
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(_con.selectedProfile.value),
                                        ),
                                      )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(_con.url.value),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              backgroundColor: AppColors.whiteColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () => _con.pickImage(false),
                                    leading: const Icon(
                                      Icons.camera,
                                      color: AppColors.primaryColor,
                                    ),
                                    title: const Text("Camera"),
                                  ),
                                  ListTile(
                                    onTap: () => _con.pickImage(true),
                                    leading: const Icon(
                                      Icons.image,
                                      color: AppColors.primaryColor,
                                    ),
                                    title: const Text("Gallery"),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            backgroundColor: AppColors.accentColor,
                            radius: 15,
                            child: Icon(
                              Icons.edit,
                              color: AppColors.whiteColor,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFiled(
                    hintText: "First name",
                    initalValue: _con.firstName.value,
                    errorMessage: _con.firstNameError,
                    onChanged: (v) => _con.firstName.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFiled(
                    hintText: "Last name",
                    initalValue: _con.lastName.value,
                    errorMessage: _con.lastNameError,
                    onChanged: (v) => _con.lastName.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFiled(
                    hintText: "Email",
                    errorMessage: "".obs,
                    initalValue: _con.email.value,
                    onChanged: (v) => _con.email.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    onPressed: () {
                      if (_con.validation()) {
                        _con.updateUserData();
                      }
                    },
                    text: "Update",
                    isLoading: _con.isUpdateLoading,
                  )
                ],
              ),
      ),
    );
  }
}
