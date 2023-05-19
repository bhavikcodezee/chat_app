import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contactModel;
  final RxBool isSelected;
  final RxBool isGroup;
  final Function(bool?) onChanged;
  const ContactTile({
    Key? key,
    required this.contactModel,
    required this.isGroup,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        onTap: isGroup.value
            ? () => onChanged(isSelected.value)
            : () => Get.toNamed(AppRoutes.chatScreen,
                arguments: [true, contactModel]),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.accentColor,
          child: Text(
            contactModel.fullName[0].toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        title: Text(
          contactModel.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: isGroup.value
            ? Checkbox(
                onChanged: onChanged,
                activeColor: AppColors.accentColor,
                value: isSelected.value,
              )
            : const SizedBox(),
      ),
    );
  }
}
