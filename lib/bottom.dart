import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:traslator/home.dart';
import 'package:traslator/scan.dart';

class BottomPages extends StatefulWidget {
  const BottomPages({super.key});

  @override
  State<BottomPages> createState() => _BottomPagesState();
}

class _BottomPagesState extends State<BottomPages> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  late Widget currentPage;
  late HomePages home;
  late ScanAndPages scan;

  @override
  void initState() {
    home = HomePages();
    scan = ScanAndPages();
    pages = [home, scan];
    currentPage = home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 500),
        backgroundColor: Colors.white,
        color: Colors.blue,
        height: 65,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            // currentPage = pages[index];
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 30,
          ),
         
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
