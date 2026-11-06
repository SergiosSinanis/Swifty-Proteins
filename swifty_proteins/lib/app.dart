import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'state/auth_state.dart';

// here we define our stateful widget + a state class that belongs to that stateful widget (tracking the things that can change and updating hte UI accordingly) so the app updates its state in real-time = this is not a screen page = this is a config file of our whole app sesssion so it works properly

class SwiftyProteinApp extends StatefulWidget { // this widget has a state that can change value as the app runs
  const SwiftyProteinApp({super.key}); // constructor = we pass to it the "key" named parameter of this stateful widget (flutter uses it to identify the builds) = super = parent class (here StatefilWidget)

// we override the parent method "createSTate()" = the stetaful widget must also have/create a state when created, so here we say which state our widget can have
  @override
  State<SwiftyProteinApp> createState() {
    return _SwiftyProteinAppState(); // we create/return an instance of the widget's state class (defined below) = now it returns an object of the specific State class that belongs to our widget
  }
}

// we create a new private STate class for our widget that extends/inherits the flutter's "State" class and connects this State object with the SwiftyProteinApp widget, we also listen to it for lifecycle changes via the observer
class _SwiftyProteinAppState extends State<SwiftyProteinApp> with WidgetsBindingObserver {
  // we override 4 funcions :

  // to initialize the state object
  @override
  void initState() {
    super.initState(); // call the parents init method
    WidgetsBinding.instance.addObserver(this);  // register "this" State object as a lifecycle observer = flutter can now notify it when the app lifecycle changes
  }

// cleaning = called when the state object is removed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // unregister the observer (clean)
    super.dispose(); // call the parent's clean method
  }

  // called when the app's lifecycle changes = the "state" arg says what has changed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) { // we logout the current user when the app is paused (not just closed) = runs in the background
      context.read<AuthState>().logout();
      // then we navigate to the login page and we clean/remove any previous routes from memory
      AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false, // remove previous routes
      );
    }
  }

// this is called when flutter renders the app : this MaterialApp object represents the whole app session that runs in the background (the screens displayed can change)
  @override
  Widget build(BuildContext context) { // we return a MaterialApp object with our specific params
    return MaterialApp(
      navigatorKey: AppRoutes.navigatorKey, // we connect our globalkey to the navigator of our whole app object
      title: 'Swifty Protein',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.login, // this is the initial screen that renders when this widget gets built (right after the native splash)
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
