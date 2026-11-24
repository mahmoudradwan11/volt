abstract class OrdersStates {}

class OrdersInitialState extends OrdersStates {}

class OrdersLoadingState extends OrdersStates {}

class OrdersSuccessState extends OrdersStates {}

class OrdersErrorState extends OrdersStates {
  final String error;
  OrdersErrorState(this.error);
}
