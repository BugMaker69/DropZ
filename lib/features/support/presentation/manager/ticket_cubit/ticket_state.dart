part of 'ticket_cubit.dart';

sealed class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

final class TicketInitial extends TicketState {}

final class TicketLoading extends TicketState {}

final class TicketFailure extends TicketState {
  final String errMessage;
  const TicketFailure(this.errMessage);
}

final class TicketSuccess extends TicketState {
  final List<ShowTickets> tickets;
  const TicketSuccess(this.tickets);
}
