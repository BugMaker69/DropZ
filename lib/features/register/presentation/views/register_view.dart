import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/views/widgets/register_view_body.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: true, // ✅ يخلي الشاشة تطلع لفوق مع الكيبورد

        // appBar: AppBar(leading: Image.asset(AssetsData.logo)),
        backgroundColor: kPrimaryColor,
        body: const RegisterViewBody(),
      ),
    );
  }
}
