import 'package:flutter/material.dart';
import 'package:lab_test_app/core/app_colors.dart';
import 'package:lab_test_app/core/location_helper.dart';
import 'package:lab_test_app/models/checkin_hive_model.dart';
import 'package:lab_test_app/models/class_model.dart';
import 'package:lab_test_app/providers/checkin_provider.dart';
import 'package:lab_test_app/services/checkin_service.dart';
import 'package:provider/provider.dart';
import '../core/app_text_styles.dart';

class CheckInPage extends StatefulWidget {
  final ClassModel classModel;

  const CheckInPage({super.key, required this.classModel});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _previousTopicController = TextEditingController();
  final _expectedTopicController = TextEditingController();
  int _mood = 3;
  bool _isLoading = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.classModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in Before Class')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.name, style: AppTextStyles.title),
              const SizedBox(height: 4),
              Text('${c.time} • ${c.room}', style: AppTextStyles.subtitle),
              const SizedBox(height: 16),
              Text('Student ID', style: AppTextStyles.body),
              const SizedBox(height: 4),
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  hintText: 'Enter your student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Previous class topic', style: AppTextStyles.body),
              const SizedBox(height: 4),
              TextFormField(
                controller: _previousTopicController,
                decoration: const InputDecoration(
                  hintText: 'What was covered last time?',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Expected topic today', style: AppTextStyles.body),
              const SizedBox(height: 4),
              TextFormField(
                controller: _expectedTopicController,
                decoration: const InputDecoration(
                  hintText: 'What do you expect to learn today?',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Mood before class', style: AppTextStyles.body),
              const SizedBox(height: 4),
              DropdownButtonFormField<int>(
                value: _mood,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 😡 Very negative')),
                  DropdownMenuItem(value: 2, child: Text('2 🙁 Negative')),
                  DropdownMenuItem(value: 3, child: Text('3 😐 Neutral')),
                  DropdownMenuItem(value: 4, child: Text('4 🙂 Positive')),
                  DropdownMenuItem(value: 5, child: Text('5 😄 Very positive')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _mood = v);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.background),
                  ),
                  onPressed: _isLoading ? null : _onSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Check-in',
                          style: AppTextStyles.button,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final classDate = DateTime(now.year, now.month, now.day).toIso8601String();
    final checkinTime = now.toIso8601String();
    final position = await getCurrentLocation();
    final double checkinLat = position.latitude;
    final double checkinLng = position.longitude;
    final c = widget.classModel;

    try {
      // 1) Save to Firestore
      final docId = await CheckinService.createCheckin(
        classId: c.id,
        className: c.name,
        studentId: _studentIdController.text.trim(),
        classDate: classDate,
        checkinTime: checkinTime,
        checkinLat: checkinLat,
        checkinLng: checkinLng,
        previousTopic: _previousTopicController.text.trim(),
        expectedTopic: _expectedTopicController.text.trim(),
        moodBefore: _mood,
      );

      // 2) Save to Hive via Provider
      await context.read<CheckinProvider>().addCheckin(
            CheckinHiveModel(
              classId: c.id,
              className: c.name,
              classDate: classDate,
              studentId: _studentIdController.text.trim(),
              moodBefore: _mood,
              checkinTime: checkinTime,
              firestoreDocId: docId,
              learnedToday: null,
            ),
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
