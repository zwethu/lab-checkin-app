import 'package:cloud_firestore/cloud_firestore.dart';

class CheckinService {
  static final _col = FirebaseFirestore.instance.collection('checkins');

  // Called at check-in time — creates a new document
  static Future<String> createCheckin({
    required String classId,
    required String className,
    required String studentId,
    required String classDate,
    required String checkinTime,
    required double checkinLat,
    required double checkinLng,
    required String previousTopic,
    required String expectedTopic,
    required int moodBefore,
  }) async {
    final doc = await _col.add({
      'classId': classId,
      'className': className,
      'studentId': studentId,
      'classDate': classDate,
      'checkinTime': checkinTime,
      'checkinLat': checkinLat,
      'checkinLng': checkinLng,
      'previousTopic': previousTopic,
      'expectedTopic': expectedTopic,
      'moodBefore': moodBefore,
      'finishTime': null,
      'finishLat': null,
      'finishLng': null,
      'learnedToday': null,
      'classFeedback': null,
    });
    return doc.id; // return Firestore document ID to store in Hive
  }

  // Called at finish time — updates the existing document
  static Future<void> finishCheckin({
    required String firestoreDocId,
    required String finishTime,
    required double finishLat,
    required double finishLng,
    required String learnedToday,
    required String? classFeedback,
  }) async {
    await _col.doc(firestoreDocId).update({
      'finishTime': finishTime,
      'finishLat': finishLat,
      'finishLng': finishLng,
      'learnedToday': learnedToday,
      'classFeedback': classFeedback,
    });
  }
}
