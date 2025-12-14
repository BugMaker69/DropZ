// lib/core/widgets/offline_banner.dart
import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        if (state is NetworkDisconnected || state is NetworkWeak) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: state is NetworkDisconnected
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.tertiaryFixed,
            child: Row(
              children: [
                Icon(
                  state is NetworkDisconnected
                      ? Icons.wifi_off
                      : Icons.signal_wifi_bad,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state is NetworkDisconnected
                        ? "No Internet Connection"
                        : "Weak Internet Connection",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<NetworkCubit>().retry(),
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
