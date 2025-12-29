import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/manager/ticket_cubit/ticket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketDetailsItem extends StatelessWidget {
  TicketDetailsItem({super.key, required this.intialShowTicket});

  final ShowTickets intialShowTicket;
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        ShowTickets? showTicket = intialShowTicket;
        if (state is TicketLoading) {
          return const CustomLoadingIndicator();
        }

        if (state is TicketFailure) {
          return CustomErrorWidget(errMessage: state.errMessage);
        }

        if (state is TicketSuccess) {
          final index = state.tickets.indexWhere(
            (t) => t.id == intialShowTicket.id,
          );
          if (index != -1) showTicket = state.tickets[index];

          return Scaffold(
            appBar: AppBar(title: Text("Support Ticket")),

            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ========= TICKET DETAILS =========
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subject",
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${showTicket.subject}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 14),

                        Row(
                          children: [
                            Text(
                              "Status:",
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            _statusBadge(context, "${showTicket.status}"),
                          ],
                        ),

                        SizedBox(height: 14),

                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${showTicket.description}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1),

                  // ========= MESSAGES LOG =========
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: showTicket.messages?.length,
                      itemBuilder: (context, index) {
                        final msg = showTicket!.messages?[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${msg?.message}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 6),
                              Text(
                                _formatDate(msg?.createdAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // ========= INPUT BOX =========
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,

                      border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "Write a message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Theme.of(context).colorScheme.surface,

                              filled: true,
                            ),
                            validator: (value) => Validators.validateRequired(
                              messageController.text,
                              "Message",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.tertiaryFixed,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context
                                  .read<TicketCubit>()
                                  .createNewMessage(
                                    showTicket!.id!,
                                    messageController.text,
                                  );
                              messageController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _statusBadge(context, String status) {
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
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "Just now";
  }
}
