import 'package:flutter/material.dart';
import 'package:lab_test_app/models/class_model.dart';
import 'package:lab_test_app/providers/checkin_provider.dart';
import 'package:lab_test_app/screens/checkin_page.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import 'finish_class_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckinProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Class Check-in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Classes', style: AppTextStyles.title),
            const SizedBox(height: 8),
            if (provider.isLoadingClasses)
              const Center(child: CircularProgressIndicator())
            else if (provider.classes.isEmpty)
              Text('No classes available.', style: AppTextStyles.body)
            else
              ...provider.classes
                  .map((c) => _buildClassCard(context, c, provider))
                  .toList(),
            const SizedBox(height: 16),
            Text('History', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Expanded(
              child: provider.history.isEmpty
                  ? Text('No history yet.', style: AppTextStyles.body)
                  : ListView.builder(
                      itemCount: provider.history.length,
                      itemBuilder: (context, index) {
                        final item = provider.history[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(
                                '${item.moodBefore}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              '${item.className} — ${item.classDate.substring(0, 10)}',
                              style: AppTextStyles.body,
                            ),
                            subtitle: Text(
                              'Student: ${item.studentId} | Learned: ${item.learnedToday ?? '-'}',
                              style: AppTextStyles.chip,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    ClassModel c,
    CheckinProvider provider,
  ) {
    final checkedIn = provider.hasCheckedIn(c.id);
    final finished = provider.hasFinished(c.id);

    String buttonText;
    Color buttonColor;
    VoidCallback? onPressed;

    if (!checkedIn && !finished) {
      buttonText = 'Check-in';
      buttonColor = AppColors.primary;
      onPressed = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckInPage(classModel: c),
          ),
        );
      };
    } else if (checkedIn && !finished) {
      buttonText = 'Finish Class';
      buttonColor = AppColors.accent;
      onPressed = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FinishClassPage(classModel: c),
          ),
        );
      };
    } else {
      buttonText = 'Completed ✓';
      buttonColor = AppColors.success;
      onPressed = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.cardBackground,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name, style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  Text(
                    '${c.time} • ${c.room}',
                    style: AppTextStyles.chip,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              onPressed: onPressed,
              child: Text(buttonText, style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }
}
