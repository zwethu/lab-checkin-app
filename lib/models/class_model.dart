class ClassModel {
  final String id;
  final String name;
  final String time;
  final String room;

  const ClassModel({
    required this.id,
    required this.name,
    required this.time,
    required this.room,
  });

  factory ClassModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return ClassModel(
      id: docId,
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      room: data['room'] ?? '',
    );
  }
}
