import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 600;
          return isWide
              ? _DesktopLayout(onGetStarted: () => context.go('/'))
              : _MobileLayout(onGetStarted: () => context.go('/'));
        },
      ),
    );
  }
}

// ─── Mobile Layout ────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _MobileLayout({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Header(onGetStarted: onGetStarted, compact: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const _HeroSection(centerAlign: true),
                  const SizedBox(height: 32),
                  _GetStartedButton(onPressed: onGetStarted),
                  const SizedBox(height: 48),
                  const _FeaturesGrid(crossAxisCount: 2),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _DesktopLayout({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Header(onGetStarted: onGetStarted, compact: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                children: [
                  const SizedBox(height: 72),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _HeroSection(centerAlign: false),
                            const SizedBox(height: 40),
                            _GetStartedButton(onPressed: onGetStarted),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  const _FeaturesGrid(crossAxisCount: 4),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onGetStarted;
  final bool compact;
  const _Header({required this.onGetStarted, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 24 : 80,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Check-in',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          // Nav button
          compact
              ? TextButton(
            onPressed: onGetStarted,
            child: Text(
              'Get Started',
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
              : SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: onGetStarted,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Get Started'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final bool centerAlign;
  const _HeroSection({required this.centerAlign});

  @override
  Widget build(BuildContext context) {
    final align = centerAlign ? TextAlign.center : TextAlign.left;
    final cross =
    centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          'Smart Lab\nCheck-in.',
          style: AppTextStyles.title.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: align,
        ),
        const SizedBox(height: 16),
        Text(
          'Check in to your lab classes, track your mood, '
              'log what you learned, and submit feedback — '
              'all in one place.',
          style: AppTextStyles.body.copyWith(
            color: Colors.black54,
            fontSize: 15,
          ),
          textAlign: align,
        ),
      ],
    );
  }
}

// ─── Features Grid ────────────────────────────────────────────────────────────

class _FeaturesGrid extends StatelessWidget {
  final int crossAxisCount;
  const _FeaturesGrid({required this.crossAxisCount});

  static const List<_FeatureItem> _features = [
    _FeatureItem(
      icon: Icons.login,
      title: 'Easy Check-in',
      description: 'Check in before class with your student ID and mood.',
    ),
    _FeatureItem(
      icon: Icons.location_on,
      title: 'GPS Verified',
      description: 'Location is recorded at check-in and check-out.',
    ),
    _FeatureItem(
      icon: Icons.notes,
      title: 'Learning Log',
      description: 'Record what you learned and give feedback after class.',
    ),
    _FeatureItem(
      icon: Icons.history,
      title: 'History',
      description: 'View all your past check-ins synced from the cloud.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    for (int i = 0; i < _features.length; i += crossAxisCount) {
      final rowItems = _features.sublist(
        i,
        (i + crossAxisCount).clamp(0, _features.length),
      );
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowItems.asMap().entries.map((entry) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: entry.key == 0 ? 0 : 8,
                    right: entry.key == rowItems.length - 1 ? 0 : 8,
                  ),
                  child: _FeatureCard(item: entry.value),
                ),
              );
            }).toList(),
          ),
        ),
      );
      if (i + crossAxisCount < _features.length) {
        rows.add(const SizedBox(height: 16));
      }
    }
    return Column(children: rows);
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: AppTextStyles.chip,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Get Started Button ───────────────────────────────────────────────────────

class _GetStartedButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GetStartedButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: const Text('Get Started'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// ─── Data Class ───────────────────────────────────────────────────────────────

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
