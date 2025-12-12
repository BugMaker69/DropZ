import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/views/widgets/show_ticket_Item.dart';
import 'package:flutter/material.dart';

class ShowTicketItemsListView extends StatelessWidget {
  final List<ShowTickets> getAllTickets;
  const ShowTicketItemsListView({super.key, required this.getAllTickets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) =>
          ShowTicketItem(showTicket: getAllTickets[index]),
      itemCount: getAllTickets.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }
}
