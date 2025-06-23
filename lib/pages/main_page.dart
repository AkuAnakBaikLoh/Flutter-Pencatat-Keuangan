import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pencatatan_keuangan/pages/profile_page.dart';
import 'package:pencatatan_keuangan/pages/home_page.dart';
import 'package:pencatatan_keuangan/pages/transaction_page.dart';
import 'package:pencatatan_keuangan/providers/transaction_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [const HomePage(), const ProfilePage()];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          (currentIndex == 0)
              ? CalendarAppBar(
                accent: Color(0xFF185A9D),
                backButton: false,
                locale: 'id',
                onDateChanged: (value) {
                  Provider.of<TransactionProvider>(
                    context,
                    listen: false,
                  ).setSelectedDate(value);
                },
                firstDate: DateTime.now().subtract(const Duration(days: 140)),
                lastDate: DateTime.now(),
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 16,
                  ),
                  child: Text('', style: GoogleFonts.montserrat(fontSize: 20)),
                ),
              ),
      floatingActionButton: Visibility(
        visible: (currentIndex == 0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const TransactionPage(),
                  ),
                )
                .then((value) {
                  setState(() {});
                });
          },
          backgroundColor: Color(0xFF185A9D),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                onTapTapped(0);
              },
              icon: const Icon(Icons.home),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                onTapTapped(1);
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
