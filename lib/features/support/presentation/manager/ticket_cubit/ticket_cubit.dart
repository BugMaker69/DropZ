import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/message.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo.dart';
import 'package:equatable/equatable.dart';

part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  TicketCubit(this.ticketRepo) : super(TicketInitial());

  final TicketRepo ticketRepo;

  List<ShowTickets> _tickets = [];

  Future<void> getAllTickets() async =>
      await CubitHandler.run<List<ShowTickets>>(
        cubit: this,
        loadingState: () => emit(TicketLoading()),
        call: () => ticketRepo.getAllTickets(),
        onSuccess: (tickets) {
          _tickets = tickets;
          emit(TicketSuccess(_tickets));
        },
        failureState: (msg) => emit(TicketFailure(msg)),
      );

  Future<void> createNewTicket(CreateTicket newTicket) async =>
      await CubitHandler.run<ShowTickets>(
        cubit: this,
        loadingState: () => emit(TicketLoading()),
        call: () => ticketRepo.createNewTicket(newTicket),
        onSuccess: (ticket) {
          _tickets.add(ticket);
          emit(TicketSuccess(_tickets));
        },
        failureState: (msg) => emit(TicketFailure(msg)),
      );

  Future<void> createNewMessage(int ticketId, String message) async =>
      await CubitHandler.run<Message>(
        cubit: this,
        loadingState: () => emit(TicketLoading()),
        call: () => ticketRepo.createNewMessage(ticketId, message),
        onSuccess: (newMessage) {
          final index = _tickets.indexWhere((t) => t.id == ticketId);
          if (index == -1) return;

          final oldTicket = _tickets[index];
          final updatedMessages = <Message>[...?oldTicket.messages, newMessage];

          _tickets[index] = oldTicket.copyWith(messages: updatedMessages);

          emit(TicketSuccess(_tickets));
        },
        failureState: (msg) => emit(TicketFailure(msg)),
      );

  Future<void> getAllMessage(int ticketId) async =>
      await CubitHandler.run<List<Message>>(
        cubit: this,
        loadingState: () => emit(TicketLoading()),
        call: () => ticketRepo.getAllMessage(ticketId),
        onSuccess: (messages) {
          final index = _tickets.indexWhere((t) => t.id == ticketId);
          if (index == -1) return;

          final oldTicket = _tickets[index];
          _tickets[index] = oldTicket.copyWith(messages: messages);

          emit(TicketSuccess(_tickets));
        },
        failureState: (msg) => emit(TicketFailure(msg)),
      );
}
