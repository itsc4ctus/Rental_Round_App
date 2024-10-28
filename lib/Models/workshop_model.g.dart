// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorKShopModelAdapter extends TypeAdapter<WorKShopModel> {
  @override
  final int typeId = 4;

  @override
  WorKShopModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorKShopModel(
      car: fields[0] as Cars,
      dateTime: fields[1] as DateTime,
      serviceAmount: fields[2] as int,
      workShopNumber: fields[3] as int,
      reciptPhoto: fields[4] as String?,
      serviceNote: fields[5] as String,
      workShopName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorKShopModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.car)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.serviceAmount)
      ..writeByte(3)
      ..write(obj.workShopNumber)
      ..writeByte(4)
      ..write(obj.reciptPhoto)
      ..writeByte(5)
      ..write(obj.serviceNote)
      ..writeByte(6)
      ..write(obj.workShopName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorKShopModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
