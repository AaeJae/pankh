// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mod_bird.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModBirdAdapter extends TypeAdapter<ModBird> {
  @override
  final int typeId = 0;

  @override
  ModBird read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModBird(
      birdID: fields[0] as int,
      rank: fields[1] as String,
      birdName: fields[2] as String,
      sciName: fields[3] as String,
      eBirdCode: fields[4] as String,
      lore: fields[7] as String,
      quality: fields[8] as String,
      hindiNames: (fields[5] as List).cast<String>(),
      marathiNames: (fields[6] as List).cast<String>(),
      birdImages: (fields[9] as List).cast<BirdImage>(),
      birdAudios: (fields[10] as List).cast<BirdAudio>(),
      birdInfo: fields[11] as BirdInfo,
      syncVersion: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModBird obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.birdID)
      ..writeByte(1)
      ..write(obj.rank)
      ..writeByte(2)
      ..write(obj.birdName)
      ..writeByte(3)
      ..write(obj.sciName)
      ..writeByte(4)
      ..write(obj.eBirdCode)
      ..writeByte(5)
      ..write(obj.hindiNames)
      ..writeByte(6)
      ..write(obj.marathiNames)
      ..writeByte(7)
      ..write(obj.lore)
      ..writeByte(8)
      ..write(obj.quality)
      ..writeByte(9)
      ..write(obj.birdImages)
      ..writeByte(10)
      ..write(obj.birdAudios)
      ..writeByte(11)
      ..write(obj.birdInfo)
      ..writeByte(12)
      ..write(obj.syncVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModBirdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BirdInfoAdapter extends TypeAdapter<BirdInfo> {
  @override
  final int typeId = 1;

  @override
  BirdInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BirdInfo(
      order: fields[0] as String,
      family: fields[1] as String,
      genus: fields[2] as String,
      specie: fields[3] as String,
      iucnStatus: fields[4] as String,
      kgMass: fields[5] as double,
      habitat: fields[6] as String,
      diet: fields[7] as String,
      mating: fields[8] as String,
      breeding: fields[9] as String,
      parasitism: fields[10] as String,
      flight: fields[11] as String,
      movement: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BirdInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.order)
      ..writeByte(1)
      ..write(obj.family)
      ..writeByte(2)
      ..write(obj.genus)
      ..writeByte(3)
      ..write(obj.specie)
      ..writeByte(4)
      ..write(obj.iucnStatus)
      ..writeByte(5)
      ..write(obj.kgMass)
      ..writeByte(6)
      ..write(obj.habitat)
      ..writeByte(7)
      ..write(obj.diet)
      ..writeByte(8)
      ..write(obj.mating)
      ..writeByte(9)
      ..write(obj.breeding)
      ..writeByte(10)
      ..write(obj.parasitism)
      ..writeByte(11)
      ..write(obj.flight)
      ..writeByte(12)
      ..write(obj.movement);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirdInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BirdImageAdapter extends TypeAdapter<BirdImage> {
  @override
  final int typeId = 2;

  @override
  BirdImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BirdImage(
      imageURL: fields[0] as String,
      isFeatured: fields[1] as bool,
      source: fields[2] as String,
      sourceCreator: fields[3] as String,
      sourceCreatorFull: fields[4] as String,
      sourceLicense: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BirdImage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.imageURL)
      ..writeByte(1)
      ..write(obj.isFeatured)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.sourceCreator)
      ..writeByte(4)
      ..write(obj.sourceCreatorFull)
      ..writeByte(5)
      ..write(obj.sourceLicense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirdImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BirdAudioAdapter extends TypeAdapter<BirdAudio> {
  @override
  final int typeId = 3;

  @override
  BirdAudio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BirdAudio(
      audioURL: fields[0] as String,
      audioType: fields[1] as String,
      length: fields[2] as int,
      source: fields[3] as String,
      sourceCreator: fields[4] as String,
      sourceLicense: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BirdAudio obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.audioURL)
      ..writeByte(1)
      ..write(obj.audioType)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.sourceCreator)
      ..writeByte(5)
      ..write(obj.sourceLicense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirdAudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
