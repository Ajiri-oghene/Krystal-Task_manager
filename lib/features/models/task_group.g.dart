// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskGroupAdapter extends TypeAdapter<TaskGroup> {
  @override
  final int typeId = 0;

  @override
  TaskGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskGroup(
      name: fields[0] as String,
      description: fields[1] as String,
      tasks: (fields[2] as List?)?.cast<TaskItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.tasks)
      ..writeByte(3)
      ..write(obj.progressColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
