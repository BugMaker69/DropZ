import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_dropdown_button_form_field.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_app_logo_only.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  // final _userRoleController = TextEditingController();

  String _selectedRole = "customer";

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _userRole = [
    DropdownMenuItem<String>(value: 'customer', child: Text('Customer')),
    DropdownMenuItem<String>(value: 'seller', child: Text('Seller')),
    DropdownMenuItem<String>(
      value: 'shipping_company',
      child: Text('Shipping Company'),
    ),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    // _userRoleController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          CustomSnakeBar(
            context,
            state.registerSuccessResponse.message.toString(),
          );

          GoRouter.of(context).push(AppRouter.kloginView);
        } else if (state is RegisterFailure) {
          CustomSnakeBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        if (state is RegisterLoading) {
          CustomLoadingIndicator();
        }
        return SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: IntrinsicHeight(
            child: Column(
              children: [
                const CustomAppBarLogoOnly(),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(.2)
                        : Colors.black.withOpacity(.2),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Join Dropz,",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          "Create an account",
                          style: Theme.of(context).textTheme.bodyLarge,
                          // style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextEdit(
                                labelText: "First name",
                                textController: _firstNameController,
                                validator: Validators.validateFirstName,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextEdit(
                                labelText: "Last name",
                                textController: _lastNameController,
                                validator: Validators.validateLastName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextEdit(
                          labelText: "Email address",
                          textController: _emailController,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        buildDropdown(
                          context: context,
                          items: _userRole,
                          onChanged: (value) {
                            _selectedRole = value!;
                          },
                          label: "Select Role",
                          value: _selectedRole,
                        ),

                        const SizedBox(height: 16),
                        CustomTextEdit(
                          labelText: "Password",
                          isPassword: true,
                          textController: _passwordController,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 16),
                        CustomTextEdit(
                          labelText: "Confirm Password",
                          isPassword: true,
                          textController: _confirmPasswordController,
                          validator: (value) =>
                              Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          isLoading: state is RegisterLoading ? true : false,
                          text: "Sign up",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<RegisterCubit>()
                                  .registerWithEmailNPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    confirmPassword:
                                        _confirmPasswordController.text,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    userRole: _selectedRole,
                                  );
                            }
                          },
                        ),
                        Center(
                          child: Text(
                            "OR",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                            // style: TextStyle(
                            //   color: Theme.of(context).colorScheme.surface,
                            // ),
                          ),
                        ),
                        CustomButton(
                          text: "Sign up with Google",
                          onPressed: () {},
                          backgroundColor: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              child: Text(
                                "Login",
                                style: Styles.textStyle16SemiBold.copyWith(
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kSecondaryColor,
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  allRightsReserved,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
