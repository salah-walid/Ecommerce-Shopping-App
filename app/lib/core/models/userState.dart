enum UserState{
  needActivation,
  userOrPasswordDoesNotExist,
  wrongData,
  ok
}

extension UserStateExtention on UserState{
  static UserState fromValue(int value){
    switch(value){
      case 1:
        return UserState.needActivation;
        break;
      case 2:
        return UserState.userOrPasswordDoesNotExist;
        break;
      case 3:
        return UserState.wrongData;
        break;
      case 0:
        return UserState.ok;
        break;
      default:
        return UserState.wrongData;
        break;
    }
  }
}