import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileViewBody extends StatelessWidget {
  ProfileViewBody({super.key});

  static final firstNameController = TextEditingController();
  static final lastNameController = TextEditingController();
  static final emailController = TextEditingController();
  static final phoneController = TextEditingController();

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileFailure) {
            return customSnakeBar(context, state.errMessage);
          }
          if (state is AuthLoggedOut) {
            print("NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
            return context.go(AppRouter.kloginView);
          }
          if (state is UserProfileSuccess) {
            firstNameController.text = state.getUserDataSuccess.firstName ?? '';
            lastNameController.text = state.getUserDataSuccess.lastName ?? '';
            emailController.text = state.getUserDataSuccess.email ?? '';
            phoneController.text = state.getUserDataSuccess.phoneNumber ?? '';
            print("firstNameController.text ${firstNameController.text}");
          }
        },
        builder: (context, state) {
          print("firstNameController.text inside ${firstNameController.text}");

          if (state is UserProfileLoading) {
            return const CustomLoadingIndicator();
          }
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit Your Profile", style: Styles.textStyle45Bold),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "First name",
                        textController: firstNameController,
                        validator: Validators.validateFirstName,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Last name",
                        textController: lastNameController,
                        validator: Validators.validateLastName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Email address",
                        textController: emailController,
                        validator: Validators.validateEmail,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Phone Number",
                        textController: phoneController,
                        validator: Validators.validatePhoneNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  "Password Changes",
                  style: Styles.textStyle45Bold.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 16),

                CustomTextEdit(
                  labelText: "Current Password",
                  isPassword: true,
                  textController: TextEditingController(),
                  // validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),

                CustomTextEdit(
                  labelText: "New Password",
                  isPassword: true,
                  textController: TextEditingController(),
                  // validator: Validators.validatePassword,
                ),

                const SizedBox(height: 16),
                CustomTextEdit(
                  labelText: "Confirm New Password",
                  isPassword: true,
                  textController: TextEditingController(),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Save Changes",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<UserProfileCubit>().updateUserData(
                        GetUserDataSuccess(
                          email: emailController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneController.text,
                        ),
                      );
                    }
                  },
                ),
                CustomButton(
                  text: "Log Out",
                  onPressed: () {
                    context.read<UserProfileCubit>().logOut();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
