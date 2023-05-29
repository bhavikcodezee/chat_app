import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contactModel;
  final RxBool isSelected;
  final RxBool isGroup;
  final bool isAdmin;
  final Function(bool?) onChanged;
  final Function()? onTap;
  const ContactTile({
    Key? key,
    required this.contactModel,
    required this.isGroup,
    required this.isAdmin,
    required this.isSelected,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
        onTap: isGroup.value ? () => onChanged(isSelected.value) : onTap,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primaryColor,
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
        trailing: isAdmin
            ? TextButton(
                onPressed: () {},
                child: Text(
                  "Admin",
                  style: TextStyle(
                    color: isAdmin ? null : Colors.red,
                  ),
                ),
              )
            : isGroup.value
                ? Checkbox(
                    onChanged: onChanged,
                    activeColor: AppColors.primaryColor,
                    value: isSelected.value,
                  )
                : const SizedBox(),
      ),
    );
  }
}
