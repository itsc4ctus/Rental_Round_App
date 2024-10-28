import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rentel_round/Models/auth_model.dart';
import 'package:rentel_round/Models/expences_model.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentel_round/Services/car_services.dart';
import 'package:rentel_round/Services/expence_services.dart';
import 'package:rentel_round/Services/status_services.dart';
import 'package:rentel_round/Services/workshop_services.dart';
import 'Models/car_model.dart';
import 'Models/status_model.dart';
import 'Models/workshop_model.dart';
import 'Notification/notificationServices.dart';
import 'Screens/Splash Screen/splash_screen.dart';

void callBackDispatcher() async {
  Workmanager().executeTask((task, input) async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(CarsAdapter());
    Hive.registerAdapter(statusAdapter());

    CarServices carServices = CarServices();
    await carServices.openBox();
    await carServices.checkPollutionDates();

    StatusServices statusServices = StatusServices();
    await statusServices.openBox();
    await statusServices.expiredCustomerNotification();

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AuthAdapter());
  Hive.registerAdapter(CarsAdapter());
  Hive.registerAdapter(statusAdapter());
  Hive.registerAdapter(expensesAdapter());
  Hive.registerAdapter(WorKShopModelAdapter());
  // await AuthServices().openBox();
  await CarServices().openBox();
  await CarServices().checkPollutionDates();
  await StatusServices().expiredCustomerNotification();
  await StatusServices().openBox();
  await ExpenceServices().openBox();
  await WorkshopServices().openBox();
  await NotificationServices().initNotification();
  if (!kIsWeb) {
    await Workmanager().initialize(callBackDispatcher, isInDebugMode: true);
    await Workmanager().registerPeriodicTask(
        "pollutionCheckTask", "pollutionCheck",
        frequency: Duration(minutes: 15));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.blue.shade50,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            textStyle: const TextStyle(fontFamily: "fredoka"),
          )),
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
                color: Colors.white, fontFamily: 'jaro', fontSize: 24),
            color: Colors.blue.shade900,
          ),
          fontFamily: 'fredoka'),
      home: const SplashScreen(),
    );
  }
}
