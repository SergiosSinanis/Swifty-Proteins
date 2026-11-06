import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/ligand_list/ligand_list_screen.dart';
import '../screens/protein_view/protein_view_screen.dart';

// all our route names listed here, so an error in a route string becomes a compile error (instead of a silent navigation failure)
class AppRoutes {
  AppRoutes._(); // a private constructor = this class is intended to never be initialized anyway

// we create a global key that gives us access to the Navigator without context (that lets us navigate pages in our app) = the navigator controls which page gets rendered (it needs "context" = Navigator.of(context).pushNamed('/login');)
// if we need to navigate without a "context" available (like when the app goes to background, we navigate to the login again) we use GlobalKey (dictionary of our routes), we need to plug manually this key that we create here to the app.dart :
// navigatorKey: AppRoutes.navigatorKey
// so then we can do in the app.dart :
// AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// our 4 pages :
// the login is the first page, so it owns '/' (the route Flutter opens first) : an initialRoute like '/login' is read as a deep link,
// and Flutter would first push '/' underneath it (an "Unknown route" page, plus a back arrow on the login leading to it)
  static const String login = '/';
  static const String register = '/register';
  static const String ligandList = '/ligands';
  static const String proteinView = '/protein-view';

// MaterialPageRoute = a Flutter class that represents a navigation route that displays a screen using Material Design page transitions = here we create routes that flutter nav can display
// this private method wraps a screen in a MaterialPageRoute object so the Navigator can display it
  static Route<dynamic> _buildRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (context) => screen, // the builder must accept a context (even if unused)
    );
  }

// the routing table :
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(const LoginScreen());
      case register:
        return _buildRoute(const RegisterScreen());
      case ligandList:
        return _buildRoute(const LigandListScreen());
      case proteinView:
        final code = settings.arguments as String;
        return _buildRoute(ProteinViewScreen(ligandCode: code));
      default:
        return _buildRoute(
          Scaffold(body: Center(child: Text('Unknown route: ${settings.name}'))),
        );
    }
  }
}
