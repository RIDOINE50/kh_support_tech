class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main
  static const String home = '/home';
  static const String about = '/about';
  static const String services = '/services';
  static const String formations = '/formations';
  static const String profile = '/profile';

  // Services
  static const String serviceDetail = '/services/detail';
  static const String bookService = '/services/book';

  // Formations
  static const String formationDetail = '/formations/detail';
  static const String formationIA = '/formations/ia';
  static const String formationDrone = '/formations/drone';
  static const String packVacances = '/formations/vacances';
  static const String incubactrices = '/formations/incubactrices';

  // Payment
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String paymentFailed = '/payment/failed';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminFormations = '/admin/formations';
  static const String adminPayments = '/admin/payments';

  // Other
  static const String assistance = '/assistance';
  static const String notifications = '/notifications';
}