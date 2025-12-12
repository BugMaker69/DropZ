import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/message.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';

abstract class TicketRepo {
  Future<Either<Failure, List<ShowTickets>>> getAllTickets();
  Future<Either<Failure, ShowTickets>> createNewTicket(CreateTicket newTicket);
  Future<Either<Failure, Message>> createNewMessage(int ticketId,String message);
  Future<Either<Failure, List<Message>>> getAllMessage(int ticketId);
}
