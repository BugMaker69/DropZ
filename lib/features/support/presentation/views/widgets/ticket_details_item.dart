import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
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
          return Center(child: CircularProgressIndicator());
        }

        if (state is TicketFailure) {
          return Center(child: Text(state.errMessage));
        }

        if (state is TicketSuccess) {
          final index = state.tickets.indexWhere(
            (t) => t.id == intialShowTicket.id,
          );
          if (index != -1) showTicket = state.tickets[index];

          print("indexx: ${intialShowTicket.id} :::   ${showTicket.id} ");
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
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subject",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${showTicket.subject}",
                          style: TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 14),

                        Row(
                          children: [
                            Text(
                              "Status:",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            _statusBadge(
                              "${showTicket.status}",
                            ), // ← هنا بتحط الحالة
                          ],
                        ),

                        SizedBox(height: 14),

                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${showTicket.description}",
                          style: TextStyle(fontSize: 16),
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
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${msg?.message}",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 6),
                              Text(
                                _formatDate(msg?.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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
                      color: Colors.grey.shade200,
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
                              fillColor: Colors.white,
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
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context
                                  .read<TicketCubit>()
                                  .createNewMessage(
                                    showTicket!.id!,
                                    messageController.text,
                                  );
                              messageController.clear();
                              print("Success");
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



/*
class TicketDetailsItem extends StatelessWidget {
  const TicketDetailsItem({super.key, required this.showTicket});

  final ShowTickets showTicket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Subject:", style: Styles.textStyle20Medium),
                  Text(
                    "Subject Subject Subject",
                    style: Styles.textStyle16Regular,
                  ),
                  Text("Description: ", style: Styles.textStyle20Medium),
                  Text(
                    "Description Description Description",
                    style: Styles.textStyle16Regular,
                  ),
                  Text("Messages: ", style: Styles.textStyle20Medium),
                  Text(
                    "Messages Messages Messages",
                    style: Styles.textStyle16Regular,
                  ),
                  Text(
                    "Messages Messages Messages",
                    style: Styles.textStyle16Regular,
                  ),
                  Text(
                    "Messages Messages Messages",
                    style: Styles.textStyle16Regular,
                  ),
                  Text(
                    _formatDate(showTicket.createdAt),
                    style: Styles.textStyle14Regular.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(top: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Write a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
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
*/

/*
class TicketDetailsItem extends StatelessWidget {
  const TicketDetailsItem({super.key, required this.showTicket});

  final ShowTickets showTicket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Support Ticket"), centerTitle: true),

      body: Column(
        children: [
          // ================= DETAILS SECTION =================
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title("Subject"),
                _value("Subject Subject Subject"),

                SizedBox(height: 10),

                _title("Description"),
                _value("Description Description Description"),
              ],
            ),
          ),

          SizedBox(height: 6),

          // ================= MESSAGES =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _messageBubble("Hello, I have an issue with ...", isUser: true),
                _messageBubble(
                  "Thanks for contacting us, we are checking.",
                  isUser: false,
                ),
                _messageBubble("Here is more detail...", isUser: true),
              ],
            ),
          ),

          // ================= INPUT BOX =================
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(top: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ================= WIDGET HELPERS =================

  Widget _title(String text) =>
      Text(text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600));

  Widget _value(String text) =>
      Text(text, style: TextStyle(fontSize: 15, color: Colors.grey.shade800));

  Widget _messageBubble(String msg, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg, style: TextStyle(fontSize: 15)),
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
*/



/*
class TicketDetailsItem extends StatelessWidget {
  TicketDetailsItem({super.key, required this.showTicket});

  final ShowTickets showTicket;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ticket Details")),

      body: Column(
        children: [
          // ================= CONTENT ==================
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- Subject ----------
                  _infoBlock(
                    title: "Subject",
                    value: "Subject Subject Subject",
                  ),

                  SizedBox(height: 14),

                  // -------- Description ----------
                  _infoBlock(
                    title: "Description",
                    value: "Description Description Description",
                  ),

                  SizedBox(height: 14),

                  // -------- Messages ----------
                  Text(
                    "Messages",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),

                  _messageItem("Messages Messages Messages"),
                  _messageItem("Messages Messages Messages"),
                  _messageItem("Messages Messages Messages"),
                ],
              ),
            ),
          ),

          // ================== INPUT BOX ==================
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(top: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Write a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ================= Helper Widgets ==================

  Widget _infoBlock({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _messageItem(String msg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(msg, style: TextStyle(fontSize: 15)),
    );
  }

  // ------------------------------------
  // Card Builder
  Widget _buildCard({required String title, required String body}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(body, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ------------------------------------
  // Message Bubble (Chat Style)
  Widget _messageBubble(String msg, {bool isSender = false}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
*/