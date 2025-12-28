import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_data_data.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final currentPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final newPassordConfirmationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void _clearControllers() {
    currentPasswordController.clear();
    newPasswordController.clear();
    newPassordConfirmationController.clear();
  }

  @override
  void dispose() {
    // 👈 تفريغ + تنظيف الذاكرة
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPassordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ يخلي الشاشة تطلع لفوق مع الكيبورد

        appBar: AppBar(title: Text("${localizations.changePassword}")),
        // backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "${localizations.changePassword}",
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge!.copyWith(fontSize: 40),
                  ),
                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "${localizations.currentPassword}",
                    isPassword: true,
                    textController: currentPasswordController,
                    // validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 16),

                  CustomTextEdit(
                    labelText: "${localizations.newPassword}",
                    isPassword: true,
                    textController: newPasswordController,
                    validator: Validators.validatePassword,
                  ),

                  const SizedBox(height: 16),
                  CustomTextEdit(
                    labelText: "${localizations.confirmNewPassword}",
                    isPassword: true,
                    textController: newPassordConfirmationController,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      newPasswordController.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "${localizations.saveNewPassword}",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<UserProfileCubit>().changePassword(
                          ChangePasswordData(
                            oldPassword: currentPasswordController.text,
                            newPassword: newPasswordController.text,
                            confirmNewPassword:
                                newPassordConfirmationController.text,
                          ),
                        );
                        _clearControllers();
                        GoRouter.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
