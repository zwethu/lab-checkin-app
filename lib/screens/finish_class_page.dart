import 'package:flutter/material.dart';
import 'package:lab_test_app/core/app_colors.dart';
import 'package:lab_test_app/core/location_helper.dart';
import 'package:lab_test_app/models/class_model.dart';
import 'package:lab_test_app/providers/checkin_provider.dart';
import 'package:lab_test_app/services/checkin_service.dart';
import 'package:provider/provider.dart';
import '../core/app_text_styles.dart';

class FinishClassPage extends StatefulWidget {
  final ClassModel classModel;

  const FinishClassPage({super.key, required this.classModel});

  @override
  State<FinishClassPage> createState() => _FinishClassPageState();
}

class _FinishClassPageState extends State<FinishClassPage> {
  final _formKey = GlobalKey<FormState>();
  final _learnedTodayController = TextEditingController();
  final _feedbackController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.classModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Finish Class')),
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
              Text('What I learned today', style: AppTextStyles.body),
              const SizedBox(height: 4),
              TextFormField(
                controller: _learnedTodayController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe briefly what you learned today',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Feedback about the class or instructor',
                  style: AppTextStyles.body),
              const SizedBox(height: 4),
              TextFormField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Any comments or suggestions? (optional)',
                  border: OutlineInputBorder(),
                ),
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
                      : Text(
                          'Submit & Finish',
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

    final provider = context.read<CheckinProvider>();
    final docId = provider.getFirestoreDocId(widget.classModel.id);

    if (docId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No check-in found for this class.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final now = DateTime.now();
    final position = await getCurrentLocation();
    final double finishLat = position.latitude;
    final double finishLng = position.longitude;

    try {
      // 1) Update Firestore document
      await CheckinService.finishCheckin(
        firestoreDocId: docId,
        finishTime: now.toIso8601String(),
        finishLat: finishLat,
        finishLng: finishLng,
        learnedToday: _learnedTodayController.text.trim(),
        classFeedback: _feedbackController.text.trim().isEmpty
            ? null
            : _feedbackController.text.trim(),
      );

      // 2) Update Hive via Provider
      await provider.finishCheckin(
        widget.classModel.id,
        _learnedTodayController.text.trim(),
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to finish class: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
