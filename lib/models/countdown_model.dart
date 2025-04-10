import 'package:uuid/uuid.dart';

class CountdownModel {
  final String id;
  String eventName;
  DateTime targetDateTime;
  bool isActive;
  bool isCompleted;
  String themeColor;
  DateTime createdAt;

  CountdownModel({
    String? id,
    required this.eventName,
    required this.targetDateTime,
    this.isActive = false,
    this.isCompleted = false,
    this.themeColor = 'purple',
    DateTime? createdAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  // Kalan süreyi hesaplama
  Duration getRemainingTime() {
    final now = DateTime.now();
    
    if (targetDateTime.isBefore(now)) {
      return Duration.zero;
    }
    
    return targetDateTime.difference(now);
  }

  // Tamamlandı mı kontrolü
  bool checkIfCompleted() {
    return DateTime.now().isAfter(targetDateTime);
  }

  // Map'e dönüştürme (veritabanı için)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'targetDateTime': targetDateTime.millisecondsSinceEpoch,
      'isActive': isActive ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'themeColor': themeColor,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Map'ten oluşturma (veritabanından)
  factory CountdownModel.fromMap(Map<String, dynamic> map) {
    return CountdownModel(
      id: map['id'],
      eventName: map['eventName'],
      targetDateTime: DateTime.fromMillisecondsSinceEpoch(map['targetDateTime']),
      isActive: map['isActive'] == 1,
      isCompleted: map['isCompleted'] == 1,
      themeColor: map['themeColor'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // Kopya oluşturma
  CountdownModel copyWith({
    String? eventName,
    DateTime? targetDateTime,
    bool? isActive,
    bool? isCompleted,
    String? themeColor,
  }) {
    return CountdownModel(
      id: id,
      eventName: eventName ?? this.eventName,
      targetDateTime: targetDateTime ?? this.targetDateTime,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      themeColor: themeColor ?? this.themeColor,
      createdAt: createdAt,
    );
  }
}