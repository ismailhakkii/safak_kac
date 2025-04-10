import 'package:flutter/material.dart';

enum AppRoute {
  home,
  countdown,
  countdownList,
  newCountdown,
  themeSettings,
}

class NavigationController with ChangeNotifier {
  // Geçerli rota
  AppRoute _currentRoute = AppRoute.home;
  
  // Geçiş parametreleri
  Map<String, dynamic> _params = {};
  
  // Navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Getters
  AppRoute get currentRoute => _currentRoute;
  Map<String, dynamic> get params => _params;
  
  // Yeni rotaya geçiş
  void navigateTo(AppRoute route, {Map<String, dynamic>? params}) {
    _currentRoute = route;
    _params = params ?? {};
    notifyListeners();
  }
  
  // Rota adını al
  String getRouteName(AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return '/';
      case AppRoute.countdown:
        return '/countdown';
      case AppRoute.countdownList:
        return '/countdowns';
      case AppRoute.newCountdown:
        return '/new-countdown';
      case AppRoute.themeSettings:
        return '/theme-settings';
    }
  }
  
  // Mevcut rota adını al
  String get currentRouteName => getRouteName(_currentRoute);
  
  // Bottom Navigation Bar item seçimi
  void selectTab(int index) {
    switch (index) {
      case 0:
        navigateTo(AppRoute.home);
        break;
      case 1:
        navigateTo(AppRoute.countdownList);
        break;
      case 2:
        navigateTo(AppRoute.themeSettings);
        break;
    }
  }
  
  // Mevcut Tab indeksini al
  int getCurrentTabIndex() {
    switch (_currentRoute) {
      case AppRoute.home:
      case AppRoute.countdown:
      case AppRoute.newCountdown:
        return 0;
      case AppRoute.countdownList:
        return 1;
      case AppRoute.themeSettings:
        return 2;
    }
  }
  
  // Geriye gitme işlemi
  void goBack() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    } else {
      navigateTo(AppRoute.home);
    }
  }
}