// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckinHiveModelAdapter extends TypeAdapter<CheckinHiveModel> {
  @override
  final int typeId = 1;

  @override
  CheckinHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckinHiveModel(
      classId: fields[0] as String,
      className: fields[1] as String,
      classDate: fields[2] as String,
      studentId: fields[3] as String,
      moodBefore: fields[4] as int,
      checkinTime: fields[5] as String,
      firestoreDocId: fields[7] as String,
      learnedToday: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckinHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.classId)
      ..writeByte(1)
      ..write(obj.className)
      ..writeByte(2)
      ..write(obj.classDate)
      ..writeByte(3)
      ..write(obj.studentId)
      ..writeByte(4)
      ..write(obj.moodBefore)
      ..writeByte(5)
      ..write(obj.checkinTime)
      ..writeByte(6)
      ..write(obj.learnedToday)
      ..writeByte(7)
      ..write(obj.firestoreDocId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckinHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
