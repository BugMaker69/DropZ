import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

class ProfileViewBody extends StatelessWidget {
  ProfileViewBody({super.key});

  // static final firstNameController = TextEditingController();
  // static final lastNameController = TextEditingController();
  // static final emailController = TextEditingController();
  // static final phoneController = TextEditingController();
  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  // String? urlImage;

  static final formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileFailure) {
            return customSnakeBar(context, state.errMessage);
          }
          if (state is UserProfileSuccess) {
            context.read<UserProfileCubit>().setUserData(
              state.getUserDataSuccess,
            );
          }
          // if (state is UserProfileSuccess) {
          //   firstNameController.text = state.getUserDataSuccess.firstName ?? '';
          //   lastNameController.text = state.getUserDataSuccess.lastName ?? '';
          //   emailController.text = state.getUserDataSuccess.email ?? '';
          //   phoneController.text = state.getUserDataSuccess.phoneNumber ?? '';
          //   urlImage = state.getUserDataSuccess.profileImage;
          //   print("firstNameController.text ${firstNameController.text}");
          // }
        },
        builder: (context, state) {
          final cubit = context.read<UserProfileCubit>();

          print(
            "firstNameController.text inside ${cubit.firstNameController.text}",
          );

          if (state is UserProfileLoading) {
            return const CustomLoadingIndicator();
          }
          if (state is UserProfileSuccess) {
            cubit.setUserData(state.getUserDataSuccess);
          }

          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit Your Profile", style: Styles.textStyle45Bold),
                ValueListenableBuilder<File?>(
                  valueListenable: selectedImage,
                  builder: (context, image, _) {
                    final hasNetworkImage =
                        cubit.profileImageUrl != null && image == null;

                    return Center(
                      child: InkWell(
                        onTap: () => pickImage(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // أهم سطر
                            border: Border.all(color: Colors.grey.shade400),
                            // borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: image != null
                              ? ClipOval(
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : hasNetworkImage
                              ? ClipOval(
                                  child: Image.network(
                                    cubit.profileImageUrl!,
                                    fit: BoxFit.scaleDown,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.grey,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          );
                                        },
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        "Tap to select an image",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "First name",
                        textController: cubit.firstNameController,
                        validator: Validators.validateFirstName,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Last name",
                        textController: cubit.lastNameController,
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
                        textController: cubit.emailController,
                        validator: Validators.validateEmail,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextEdit(
                        labelText: "Phone Number",
                        textController: cubit.phoneController,
                        validator: Validators.validatePhoneNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomButton(
                  text: "Save Changes",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<UserProfileCubit>().updateUserData(
                        GetUserDataSuccess(
                          email: cubit.emailController.text,
                          firstName: cubit.firstNameController.text,
                          lastName: cubit.lastNameController.text,
                          phoneNumber: cubit.phoneController.text,
                          profileImage: selectedImage.value,
                        ),
                      );
                      GoRouter.of(context).pop();
                    }
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
