// lib/features/cart/views/checkout_view.dart
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/views/widgets/checkout_form.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo_imp.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text("${localizations.checkout}")),
      body: BlocProvider(
        create: (_) => CheckoutCubit(getIt.get<CheckoutRepoImp>()),
        child: const CheckoutForm(),
      ),
    );
  }
}
