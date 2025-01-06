import 'package:flutter/material.dart';
import 'package:fma/templates/Themes.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavBarGradient =
        Theme.of(context).extension<GradientTheme>()?.bottomNavBarGradient;

    return bottomNavBarGradient != null
        ? Container(
            decoration: BoxDecoration(
              gradient: bottomNavBarGradient,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: _getCurrentIndex(context),
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, '/transactions');
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(context, '/reports');
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.receipt), label: 'Transaction'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics), label: 'Report'),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  int _getCurrentIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/transactions':
        return 1;
      case '/reports':
        return 2;
      default:
        return 0;
    }
  }
}
