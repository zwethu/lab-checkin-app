import 'package:go_router/go_router.dart';
import '../models/class_model.dart';
import '../screens/landing_page.dart';
import '../screens/home_page.dart';
import '../screens/checkin_page.dart';
import '../screens/finish_class_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/landing',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/checkin',
      builder: (context, state) {
        final classModel = state.extra as ClassModel;
        return CheckInPage(classModel: classModel);
      },
    ),
    GoRoute(
      path: '/finish',
      builder: (context, state) {
        final classModel = state.extra as ClassModel;
        return FinishClassPage(classModel: classModel);
      },
    ),
  ],
);
