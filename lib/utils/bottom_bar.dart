import 'package:flutter/material.dart';

class bottomNavigationBar extends StatefulWidget {
  final String userId;
  const bottomNavigationBar({Key? key, required this.userId}) : super(key: key);

  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState();
}

int _currentIndex = 0;

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          // Navigator.pushReplacementNamed(context, 'home_screen');
          Navigator.pushNamed(context, 'home_screen', arguments: {
            'userId': widget.userId,
          });
          break;
        case 1:
          // Navigator.pushReplacementNamed(context, 'detail_bmi');
          Navigator.pushNamed(context, 'statistik', arguments: {
            'userId': widget.userId,
          });
          break;
        case 2:
          // Navigator.pushReplacementNamed(context, 'profile_page');
          Navigator.pushNamed(context, 'profile_page', arguments: {
            'userId': widget.userId,
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            size: 40,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            size: 40,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 40,
          ),
          label: '',
        ),
      ],
      onTap: onTabTapped,
      selectedItemColor: Colors.blue,
    );
  }
}
