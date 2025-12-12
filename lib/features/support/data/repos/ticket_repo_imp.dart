import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/create_ticket.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/message.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo.dart';

class TicketRepoImp extends TicketRepo {
  ApiService apiService;
  TicketRepoImp(this.apiService);

  @override
  Future<Either<Failure, Message>> createNewMessage(
    int ticketId,
    String message,
  ) async {
    try {
      var result = await apiService.post(
        endPoint: "/support/tickets/$ticketId/messages/",
        data: {"message": message},
      );
      print("DAta AddProducts + ${result}");

      Message data = Message.fromJson(result);
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShowTickets>> createNewTicket(
    CreateTicket newTicket,
  ) async {
    try {
      var result = await apiService.post(
        endPoint: "/support/tickets/",
        data: newTicket.toJson(),
      );
      print("DAta AddProducts + ${result}");

      ShowTickets data = ShowTickets.fromJson(result);
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getAllMessage(int ticketId) async {
    try {
      var result = await apiService.get(
        endPoint: "/support/tickets/$ticketId/messages/",
      );
      print("DAta AddProducts + ${result}");

      List<Message> data = (result as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShowTickets>>> getAllTickets() async {
    try {
      var result = await apiService.get(
        endPoint: "/support/tickets/",
      );
      print("DAta AddProducts + ${result}");

      List<ShowTickets> data = (result as List<dynamic>)
          .map((e) => ShowTickets.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(data);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
