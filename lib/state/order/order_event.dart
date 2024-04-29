part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent{
  const LoadOrdersEvent({
    required this.userId,
  });
  final String userId;

  @override
  List<Object?> get props => [userId];
}
