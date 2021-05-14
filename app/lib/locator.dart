/*
 * Deppendency ingection manager
*/
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/localDatabaseService.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/core/services/paymentService.dart';
import 'package:ecom/core/services/notificationService.dart';
import 'package:ecom/core/services/phoneVerificationService.dart';
import 'package:get_it/get_it.dart';


//! Global locator variable
GetIt locator = GetIt.instance;

//! Function to be called before the runApp function
void setupLocator() {
  //Add services here
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => LocalDatabaseService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => AuthentificationService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => PhoneVerficationService());

}
