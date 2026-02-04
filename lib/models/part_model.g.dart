// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartModelAdapter extends TypeAdapter<PartModel> {
  @override
  final int typeId = 4;

  @override
  PartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartModel(
      type: fields[0] as PartType,
      amount: fields[1] as int,
      variables: (fields[2] as Map?)?.cast<VariableType, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PartModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.variables);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VariableTypeAdapter extends TypeAdapter<VariableType> {
  @override
  final int typeId = 0;

  @override
  VariableType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VariableType.none;
      case 1:
        return VariableType.pressure;
      case 2:
        return VariableType.degreescelsius;
      case 3:
        return VariableType.diameter;
      case 4:
        return VariableType.perimeter;
      case 5:
        return VariableType.minorperimeter;
      case 6:
        return VariableType.majorperimeter;
      case 7:
        return VariableType.insulating;
      case 8:
        return VariableType.linearmeter;
      case 9:
        return VariableType.squaremeter;
      case 10:
        return VariableType.side;
      case 11:
        return VariableType.width;
      case 12:
        return VariableType.height;
      case 13:
        return VariableType.majordiameter;
      case 14:
        return VariableType.minordiameter;
      case 15:
        return VariableType.length;
      case 16:
        return VariableType.weldbead;
      case 17:
        return VariableType.extrados;
      case 18:
        return VariableType.amount;
      case 19:
        return VariableType.multiplierFactor;
      case 20:
        return VariableType.sector;
      case 21:
        return VariableType.description;
      case 22:
        return VariableType.coating;
      case 23:
        return VariableType.parts;
      default:
        return VariableType.none;
    }
  }

  @override
  void write(BinaryWriter writer, VariableType obj) {
    switch (obj) {
      case VariableType.none:
        writer.writeByte(0);
        break;
      case VariableType.pressure:
        writer.writeByte(1);
        break;
      case VariableType.degreescelsius:
        writer.writeByte(2);
        break;
      case VariableType.diameter:
        writer.writeByte(3);
        break;
      case VariableType.perimeter:
        writer.writeByte(4);
        break;
      case VariableType.minorperimeter:
        writer.writeByte(5);
        break;
      case VariableType.majorperimeter:
        writer.writeByte(6);
        break;
      case VariableType.insulating:
        writer.writeByte(7);
        break;
      case VariableType.linearmeter:
        writer.writeByte(8);
        break;
      case VariableType.squaremeter:
        writer.writeByte(9);
        break;
      case VariableType.side:
        writer.writeByte(10);
        break;
      case VariableType.width:
        writer.writeByte(11);
        break;
      case VariableType.height:
        writer.writeByte(12);
        break;
      case VariableType.majordiameter:
        writer.writeByte(13);
        break;
      case VariableType.minordiameter:
        writer.writeByte(14);
        break;
      case VariableType.length:
        writer.writeByte(15);
        break;
      case VariableType.weldbead:
        writer.writeByte(16);
        break;
      case VariableType.extrados:
        writer.writeByte(17);
        break;
      case VariableType.amount:
        writer.writeByte(18);
        break;
      case VariableType.multiplierFactor:
        writer.writeByte(19);
        break;
      case VariableType.sector:
        writer.writeByte(20);
        break;
      case VariableType.description:
        writer.writeByte(21);
        break;
      case VariableType.coating:
        writer.writeByte(22);
        break;
      case VariableType.parts:
        writer.writeByte(23);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariableTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartTypeAdapter extends TypeAdapter<PartType> {
  @override
  final int typeId = 1;

  @override
  PartType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartType.none;
      case 1:
        return PartType.bend;
      case 2:
        return PartType.tee;
      case 3:
        return PartType.benddegree45;
      case 4:
        return PartType.conical;
      case 5:
        return PartType.flange;
      case 6:
        return PartType.cap;
      case 7:
        return PartType.cover;
      case 8:
        return PartType.dishedhead;
      case 9:
        return PartType.reducingcoupling;
      case 10:
        return PartType.valvebox;
      case 11:
        return PartType.insulationfinish;
      case 12:
        return PartType.angleiron;
      case 13:
        return PartType.pipeshoe;
      case 14:
        return PartType.backstay;
      case 15:
        return PartType.asianconicalheat;
      case 16:
        return PartType.squaretoround;
      default:
        return PartType.none;
    }
  }

  @override
  void write(BinaryWriter writer, PartType obj) {
    switch (obj) {
      case PartType.none:
        writer.writeByte(0);
        break;
      case PartType.bend:
        writer.writeByte(1);
        break;
      case PartType.tee:
        writer.writeByte(2);
        break;
      case PartType.benddegree45:
        writer.writeByte(3);
        break;
      case PartType.conical:
        writer.writeByte(4);
        break;
      case PartType.flange:
        writer.writeByte(5);
        break;
      case PartType.cap:
        writer.writeByte(6);
        break;
      case PartType.cover:
        writer.writeByte(7);
        break;
      case PartType.dishedhead:
        writer.writeByte(8);
        break;
      case PartType.reducingcoupling:
        writer.writeByte(9);
        break;
      case PartType.valvebox:
        writer.writeByte(10);
        break;
      case PartType.insulationfinish:
        writer.writeByte(11);
        break;
      case PartType.angleiron:
        writer.writeByte(12);
        break;
      case PartType.pipeshoe:
        writer.writeByte(13);
        break;
      case PartType.backstay:
        writer.writeByte(14);
        break;
      case PartType.asianconicalheat:
        writer.writeByte(15);
        break;
      case PartType.squaretoround:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
