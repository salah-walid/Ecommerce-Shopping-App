enum OrderState{
  accepted,
  inProgress,
  shippeded,
  delivered,
  completed,
  canceledByUser,
  canceledByAdmin,
}

extension OrderStateExtension on OrderState{

  String get name{
    switch(this){

      case OrderState.accepted:
        return "Accepted";
        break;
      case OrderState.inProgress:
        return "In Progress";
        break;
      case OrderState.shippeded:
        return "Shipped";
        break;
      case OrderState.delivered:
        return "Delivered";
        break;
      case OrderState.completed:
        return "Completed";
        break;
      case OrderState.canceledByUser:
        return "Canceled by user";
        break;
      case OrderState.canceledByAdmin:
        return "Canceled by admin";
        break;
      default:
        return "none";
        break;

    }
  }

  int get value{

    switch(this){

      case OrderState.accepted:
        return 0;
        break;
      case OrderState.inProgress:
        return 1;
        break;
      case OrderState.shippeded:
        return 2;
        break;
      case OrderState.delivered:
        return 3;
        break;
      case OrderState.completed:
        return 4;
        break;
      case OrderState.canceledByUser:
        return 5;
        break;
      case OrderState.canceledByAdmin:
        return 6;
        break;
      default:
        return 0;
        break;
    }

  }
  
  static OrderState fromValue(int value){

    switch(value){

      case 0:
        return OrderState.accepted;
        break;
      case 1:
        return OrderState.inProgress;
        break;
      case 2:
        return OrderState.shippeded;
        break;
      case 3:
        return OrderState.delivered;
        break;
      case 4:
        return OrderState.completed;
        break;
      case 5:
        return OrderState.canceledByUser;
        break;
      case 6:
        return OrderState.canceledByAdmin;
        break;
      default:
        return OrderState.accepted;
        break;

    }

  }

}