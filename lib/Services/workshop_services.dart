import 'package:hive/hive.dart';
import 'package:rentel_round/Models/workshop_model.dart';

class WorkshopServices {
  Box<WorKShopModel>? workshopBox;
  Box<WorKShopModel>? takeToWork;
  Box<WorKShopModel>? completedWork;
  Box<WorKShopModel>? completedWorkForExp;

  Future<void> openBox() async {
    workshopBox = await Hive.openBox("WorkShopBox");
    takeToWork = await Hive.openBox("TaketoWork");
    completedWork = await Hive.openBox("CompletedWork");
    completedWorkForExp = await Hive.openBox("CompletedWorkForExp");
  }

  Future<void> closeBox() async {
    workshopBox!.close();
    takeToWork!.close();
    completedWork!.close();
    completedWorkForExp!.close();
  }

  Future<void> addWorkshop(WorKShopModel service) async {
    if (workshopBox == null) {
      await openBox();
    }
    await workshopBox!.add(service);
  }

  Future<void> addTakeToWork(WorKShopModel service) async {
    if (takeToWork == null) {
      await openBox();
    }
    await takeToWork!.add(service);
  }

  Future<void> addCompleted(WorKShopModel service) async {
    if (completedWork == null) {
      await openBox();
    }
    await completedWork!.add(service);
  }

  Future<void> addCompletedForExp(WorKShopModel service) async {
    if (completedWorkForExp == null) {
      await openBox();
    }
    await completedWorkForExp!.add(service);
  }

  Future<List<WorKShopModel>> getWorkshopList() async {
    if (workshopBox == null) {
      await openBox();
    }
    return workshopBox!.values.toList();
  }

  Future<List<WorKShopModel>> getTakeToWork() async {
    if (takeToWork == null) {
      await openBox();
    }
    return takeToWork!.values.toList();
  }

  Future<List<WorKShopModel>> getCompleted() async {
    if (completedWork == null) {
      await openBox();
    }
    return completedWork!.values.toList();
  }

  Future<List<WorKShopModel>> getCompletedForExp() async {
    if (completedWorkForExp == null) {
      await openBox();
    }
    return completedWorkForExp!.values.toList();
  }

  Future<void> updateCompletedWork(
      WorKShopModel workshop, String vehicleNo) async {
    if (completedWork == null) {
      await openBox();
    }
    for (var key in completedWork!.keys) {
      final work = completedWork!.get(key) as WorKShopModel;
      if (work.car.vehicleNo == vehicleNo) {
        await completedWork!.put(key, workshop);
        break;
      }
    }
  }

  Future<void> clearBox() async {
    if (workshopBox == null) {
      await openBox();
    }
    if (takeToWork == null) {
      await openBox();
    }
    if (completedWork == null) {
      await openBox();
    }
    if (completedWorkForExp == null) {
      await openBox();
    }
    await workshopBox!.clear();
    await takeToWork!.clear();
    await completedWork!.clear();
    await completedWorkForExp!.clear();
  }
}
