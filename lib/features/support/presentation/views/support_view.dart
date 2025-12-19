import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/manager/ticket_cubit/ticket_cubit.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/views/widgets/show_ticket_items_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportView extends StatelessWidget {
  SupportView({super.key});

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TicketCubit(getIt.get<TicketRepoImp>())..getAllTickets(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Support")),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              onPressed: () => _showInputDialog(context),
              icon: const Icon(Icons.contact_support_outlined),
              label: const Text("New Ticket"),
            );
          },
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CustomLoadingIndicator());
            }

            if (state is TicketFailure) {
              return Center(
                child: CustomErrorWidget(errMessage: state.errMessage),
              );
            }

            if (state is TicketSuccess) {
              final tickets = state.tickets;

              if (tickets.isEmpty) {
                return const Center(
                  child: CustomErrorWidget(errMessage: "No Tickets available"),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShowTicketItemsListView(getAllTickets: tickets),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showInputDialog(parentContext) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text("Add New Ticket", style: Styles.textStyle16SemiBold),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextEdit(
                    labelText: "Subject",
                    textController: subjectController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Subject"),
                  ),
                  const SizedBox(height: 15),
                  CustomTextEdit(
                    labelText: "Description",
                    textController: descriptionController,
                    keyboardType: TextInputType.multiline,
                    validator: (value) =>
                        Validators.validateRequired(value, "Description"),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                subjectController.clear();
                descriptionController.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  BlocProvider.of<TicketCubit>(parentContext).createNewTicket(
                    CreateTicket(
                      subject: subjectController.text,
                      description: descriptionController.text,
                    ),
                  );
                  subjectController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
