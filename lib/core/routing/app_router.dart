import 'package:go_router/go_router.dart';

// Auth
import 'package:sharyan/features/auth/presentation/pages/splash_screen.dart';
import 'package:sharyan/features/auth/presentation/pages/onboarding_page.dart';
import 'package:sharyan/features/auth/presentation/pages/login_page.dart';
import 'package:sharyan/features/auth/presentation/pages/register_page.dart';

// Home
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:sharyan/features/gamification/presentation/pages/top_donors_page.dart';

// Search
import 'package:sharyan/features/search/presentation/pages/search_directory_page.dart';

// Profile
import 'package:sharyan/features/donor_profile/presentation/pages/profile_page.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/edit_profile_page.dart';

// History
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';

// Notifications
import 'package:sharyan/features/blood_emergencies/presentation/pages/urgent_requests_page.dart';

// Hospital
import 'package:sharyan/features/hospital/presentation/pages/hospital_dashboard_page.dart';
import 'package:sharyan/features/hospital/presentation/pages/create_request_page.dart';
import 'package:sharyan/features/hospital/presentation/pages/responders_list_page.dart';

// More
import 'package:sharyan/features/more/presentation/pages/settings_page.dart';
import 'package:sharyan/features/more/presentation/pages/report_issue_page.dart';
import 'package:sharyan/features/more/presentation/pages/about_app_page.dart';
import 'package:sharyan/features/more/presentation/pages/contact_us_page.dart';
import 'package:sharyan/features/more/presentation/pages/invite_friend_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Dashboard Navigation
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const DonationHistoryPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Sub Features
      GoRoute(
        path: '/top-donors',
        builder: (context, state) => const TopDonorsPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchDirectoryPage(),
      ),
      GoRoute(
        path: '/urgent-requests',
        builder: (context, state) => const UrgentRequestsPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),

      // Hospital
      GoRoute(
        path: '/hospital-dashboard',
        builder: (context, state) => const HospitalDashboardPage(),
      ),
      GoRoute(
        path: '/create-request',
        builder: (context, state) => const CreateRequestPage(),
      ),
      GoRoute(
        path: '/responders-list',
        builder: (context, state) => const RespondersListPage(),
      ),

      // More Options
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/report-issue',
        builder: (context, state) => const ReportIssuePage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutAppPage(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactUsPage(),
      ),
      GoRoute(
        path: '/invite',
        builder: (context, state) => const InviteFriendPage(),
      ),
    ],
  );
}
