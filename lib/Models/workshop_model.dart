import 'package:hive/hive.dart';
import 'package:rentel_round/Models/car_model.dart';

part 'workshop_model.g.dart';

@HiveType(typeId: 4)
class WorKShopModel {
  WorKShopModel({
    required this.car,
    required this.dateTime,
    this.serviceAmount = 0,
    required this.workShopNumber,
    this.reciptPhoto,
    this.serviceNote = "No Note",
    this.workShopName,
  });

  @HiveField(0)
  late Cars car;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late int serviceAmount;

  @HiveField(3)
  late int workShopNumber;

  @HiveField(4)
  late String? reciptPhoto;

  @HiveField(5)
  late String serviceNote;

  @HiveField(6)
  late String? workShopName;
}
