import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/message.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo.dart';
import 'package:equatable/equatable.dart';

part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  TicketCubit(this.ticketRepo) : super(TicketInitial());

  TicketRepo ticketRepo;

  List<ShowTickets> _tickets = [];

  Future<void> getAllTickets() async {
    emit(TicketLoading());

    var result = await ticketRepo.getAllTickets();

    print("getAllTickets Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("tickets Failure: ${failure.errMessage}");
        emit(TicketFailure(failure.errMessage));
      },
      (tickets) {
        print("tickets Success: $tickets");
        _tickets = tickets;
        emit(TicketSuccess(_tickets));
      },
    );
  }

  Future<void> createNewTicket(CreateTicket newTicket) async {
    emit(TicketLoading());

    var result = await ticketRepo.createNewTicket(newTicket);

    print("createNewTicket Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("tickets Failure: ${failure.errMessage}");
        emit(TicketFailure(failure.errMessage));
      },
      (ticket) {
        print("tickets Success: $ticket");
        _tickets.add(ticket);
        emit(TicketSuccess(_tickets));
      },
    );
  }

  Future<void> createNewMessage(int ticketId, String message) async {
    emit(TicketLoading());

    var result = await ticketRepo.createNewMessage(ticketId, message);

    print("createNewTicket Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("tickets Failure: ${failure.errMessage}");
        emit(TicketFailure(failure.errMessage));
      },
      (newMessage) {
        final index = _tickets.indexWhere((t) => t.id == ticketId);
        if (index != -1) {
          final oldTicket = _tickets[index];

          // إنشاء نسخة جديدة من الرسائل مع الرسالة الجديدة
          final updatedMessages = <Message>[...?oldTicket.messages, newMessage];

          // إنشاء نسخة جديدة من التذكرة مع الرسائل المحدثة
          final updatedTicket = oldTicket.copyWith(messages: updatedMessages);

          // تحديث القائمة الداخلية
          _tickets[index] = updatedTicket;
          print("tickets Success: $newMessage");
          emit(TicketSuccess(_tickets));
        }
      },
    );
  }

  Future<void> getAllMessage(int ticketId, String message) async {
    emit(TicketLoading());

    var result = await ticketRepo.getAllMessage(ticketId);

    print("createNewTicket Result: $result"); // للتحقق
    result.fold(
      (failure) {
        print("tickets Failure: ${failure.errMessage}");
        emit(TicketFailure(failure.errMessage));
      },
      (messages) {
        final index = _tickets.indexWhere((t) => t.id == ticketId);
        if (index != -1) {
          final oldTicket = _tickets[index];

          // نسخ القائمة مع الرسائل الجديدة
          final updatedTicket = oldTicket.copyWith(messages: messages);

          _tickets[index] = updatedTicket;
          print("tickets Success: $messages");
          emit(TicketSuccess(_tickets));
        }
      },
    );
  }
}
