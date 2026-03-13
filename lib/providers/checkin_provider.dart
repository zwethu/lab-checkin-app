import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/checkin_hive_model.dart';
import '../models/class_model.dart';

class CheckinProvider extends ChangeNotifier {
  List<CheckinHiveModel> _history = [];
  List<ClassModel> _classes = [];
  bool _isLoadingClasses = false;

  final Map<String, bool> _checkedIn = {};
  final Map<String, bool> _finished = {};

  List<CheckinHiveModel> get history => _history;
  List<ClassModel> get classes => _classes;
  bool get isLoadingClasses => _isLoadingClasses;

  bool hasCheckedIn(String classId) => _checkedIn[classId] ?? false;
  bool hasFinished(String classId) => _finished[classId] ?? false;

  // ─── Fetch classes from Firestore ───────────────────────────────────────────
  Future<void> fetchClasses() async {
    _isLoadingClasses = true;
    notifyListeners();

    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('classes').get();
      _classes = snapshot.docs
          .map((doc) => ClassModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (_) {
      _classes = [];
    }

    _isLoadingClasses = false;
    notifyListeners();
  }

  // ─── Sync today's Firestore checkins into Hive on startup ───────────────────
  Future<void> syncFromFirestore() async {
    try {
      final today = DateTime.now();
      final todayStr =
      DateTime(today.year, today.month, today.day).toIso8601String();

      final snapshot = await FirebaseFirestore.instance
          .collection('checkins')
          .where('classDate', isGreaterThanOrEqualTo: todayStr)
          .get();

      final box = Hive.box<CheckinHiveModel>('checkin_history');

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final exists = box.values.any((h) => h.firestoreDocId == doc.id);
        if (!exists) {
          await box.add(CheckinHiveModel(
            classId: data['classId'] ?? '',
            className: data['className'] ?? '',
            classDate: data['classDate'] ?? '',
            studentId: data['studentId'] ?? '',
            moodBefore: (data['moodBefore'] ?? 3) as int,
            checkinTime: data['checkinTime'] ?? '',
            firestoreDocId: doc.id,
            learnedToday: data['learnedToday'],
          ));
        }
      }
    } catch (_) {
      // silently fail — offline Hive still works
    }

    loadHistory();
  }

  // ─── Load history from Hive ──────────────────────────────────────────────────
  void loadHistory() {
    final box = Hive.box<CheckinHiveModel>('checkin_history');
    _history = box.values.toList().reversed.toList();

    _checkedIn.clear();
    _finished.clear();

    for (final h in _history) {
      if (h.learnedToday == null) {
        _checkedIn[h.classId] = true;
      } else {
        _finished[h.classId] = true;
      }
    }

    notifyListeners();
  }

  // ─── Add check-in to Hive ────────────────────────────────────────────────────
  Future<void> addCheckin(CheckinHiveModel model) async {
    final box = Hive.box<CheckinHiveModel>('checkin_history');
    await box.add(model);
    loadHistory();
  }

  // ─── Finish class — update Hive entry ────────────────────────────────────────
  Future<void> finishCheckin(String classId, String learnedToday) async {
    final box = Hive.box<CheckinHiveModel>('checkin_history');

    final entryKey = box.keys.lastWhere(
          (key) {
        final entry = box.get(key);
        return entry != null &&
            entry.classId == classId &&
            entry.learnedToday == null;
      },
      orElse: () => null,
    );

    if (entryKey == null) return;

    final existing = box.get(entryKey) as CheckinHiveModel;

    await box.put(
      entryKey,
      CheckinHiveModel(
        classId: existing.classId,
        className: existing.className,
        classDate: existing.classDate,
        studentId: existing.studentId,
        moodBefore: existing.moodBefore,
        checkinTime: existing.checkinTime,
        firestoreDocId: existing.firestoreDocId,
        learnedToday: learnedToday,
      ),
    );

    loadHistory();
  }

  // ─── Get Firestore doc ID for finish step ────────────────────────────────────
  String? getFirestoreDocId(String classId) {
    try {
      return _history
          .firstWhere(
              (h) => h.classId == classId && h.learnedToday == null)
          .firestoreDocId;
    } catch (_) {
      return null;
    }
  }
}
