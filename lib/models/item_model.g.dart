// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 3;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      id: fields[0] as String,
      budgetId: fields[1] as String,
      index: fields[2] as int,
      sector: fields[3] as String,
      description: fields[4] as String,
      coating: fields[5] as String,
      pressure: fields[6] as double,
      degreesCelsius: fields[7] as double,
      diameter: fields[8] as double,
      perimeter: fields[9] as double,
      insulating: fields[10] as String,
      linearMeter: fields[11] as double,
      squareMeter: fields[12] as double,
      multiplierFactor: fields[13] as int,
      parts: (fields[14] as List?)?.cast<PartModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.budgetId)
      ..writeByte(2)
      ..write(obj.index)
      ..writeByte(3)
      ..write(obj.sector)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.coating)
      ..writeByte(6)
      ..write(obj.pressure)
      ..writeByte(7)
      ..write(obj.degreesCelsius)
      ..writeByte(8)
      ..write(obj.diameter)
      ..writeByte(9)
      ..write(obj.perimeter)
      ..writeByte(10)
      ..write(obj.insulating)
      ..writeByte(11)
      ..write(obj.linearMeter)
      ..writeByte(12)
      ..write(obj.squareMeter)
      ..writeByte(13)
      ..write(obj.multiplierFactor)
      ..writeByte(14)
      ..write(obj.parts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
