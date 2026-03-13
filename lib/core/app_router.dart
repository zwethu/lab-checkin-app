import 'package:go_router/go_router.dart';
import '../models/class_model.dart';
import '../screens/landing_page.dart';
import '../screens/home_page.dart';
import '../screens/checkin_page.dart';
import '../screens/finish_class_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (state.matchedLocation == '/landing') return null;
      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/checkin',
        name: 'checkin',
        builder: (context, state) {
          final classModel = state.extra as ClassModel;
          return CheckInPage(classModel: classModel);
        },
      ),
      GoRoute(
        path: '/finish',
        name: 'finish',
        builder: (context, state) {
          final classModel = state.extra as ClassModel;
          return FinishClassPage(classModel: classModel);
        },
      ),
    ],
  );
}
