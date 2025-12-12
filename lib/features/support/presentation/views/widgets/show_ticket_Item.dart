import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/manager/ticket_cubit/ticket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShowTicketItem extends StatelessWidget {
  const ShowTicketItem({super.key, required this.showTicket});

  final ShowTickets showTicket;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("${showTicket.subject}")],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${showTicket.description}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          SizedBox(width: 20),
          Text("Messages: ${showTicket.messages?.length}"),
        ],
      ),
      trailing: _statusBadge("${showTicket.status}"),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(16),
      ),
      onTap: () {
        final cubit = context.read<TicketCubit>();

        GoRouter.of(context).push(
          AppRouter.kCustomerSupportDetails,
          extra: {"ticket": showTicket, "cubit": cubit},
        );
      },
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case "open":
        bg = Colors.green.shade100;
        text = Colors.green.shade800;
        break;

      case "in progress":
        bg = Colors.orange.shade100;
        text = Colors.orange.shade800;
        break;

      case "pending":
        bg = Colors.blue.shade100;
        text = Colors.blue.shade800;
        break;

      case "closed":
        bg = Colors.red.shade100;
        text = Colors.red.shade800;
        break;

      default:
        bg = Colors.grey.shade300;
        text = Colors.black87;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
