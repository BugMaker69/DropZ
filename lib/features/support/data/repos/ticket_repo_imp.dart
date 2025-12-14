import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/message.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo.dart';

class TicketRepoImp extends TicketRepo {
  final ApiService apiService;
  TicketRepoImp(this.apiService);

  @override
  Future<Either<Failure, Message>> createNewMessage(
    int ticketId,
    String message,
  ) => RepoRequest.call<Message>(
    request: () => apiService.post(
      endPoint: "/support/tickets/$ticketId/messages/",
      data: {"message": message},
    ),
    parser: (data) => Message.fromJson(data),
  );

  @override
  Future<Either<Failure, ShowTickets>> createNewTicket(
    CreateTicket newTicket,
  ) => RepoRequest.call<ShowTickets>(
    request: () => apiService.post(
      endPoint: "/support/tickets/",
      data: newTicket.toJson(),
    ),
    parser: (data) => ShowTickets.fromJson(data),
  );

  @override
  Future<Either<Failure, List<Message>>> getAllMessage(int ticketId) =>
      RepoRequest.call<List<Message>>(
        request: () =>
            apiService.get(endPoint: "/support/tickets/$ticketId/messages/"),
        parser: (data) => (data as List)
            .map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Future<Either<Failure, List<ShowTickets>>> getAllTickets() =>
      RepoRequest.call<List<ShowTickets>>(
        request: () => apiService.get(endPoint: "/support/tickets/"),
        parser: (data) {
          return (data as List)
              .map((e) => ShowTickets.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
}
