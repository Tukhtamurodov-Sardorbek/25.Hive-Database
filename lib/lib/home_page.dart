import 'package:flutter/material.dart';
import 'package:hiveldb/lib/optimized_version.dart';
import 'package:hiveldb/lib/simple_version.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const[
          SimpleVersion(),
          OptimizedVersion()
        ],
        onPageChanged: (index){
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: 'Simple'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: 'Optimized'),
        ],
        currentIndex: _currentPage,
        onTap: (index){
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
