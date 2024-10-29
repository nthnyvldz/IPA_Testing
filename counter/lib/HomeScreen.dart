import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'results_table_screen.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'db/database_helper.dart';
import 'CounterScreen.dart';
import 'dart:io';
import 'package:counter/sales.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int averageCount = 0;

  @override
  void initState() {
    super.initState();
    fetchAverageCount();
  }

  Future<void> fetchAverageCount() async {
    final results = await DatabaseHelper.instance.fetchResults();
    int totalCount = 0;
    if (results.isNotEmpty) {
      for (var result in results) {
        totalCount += result['total_count'] as int;
      }
      setState(() {
        averageCount = totalCount ~/ results.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          50,
          MediaQuery.of(context).size.width < 370
              ? 100
              : MediaQuery.of(context).size.width > 420
                  ? 200
                  : 170,
          50,
          50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width < 370
                      ? 100
                      : MediaQuery.of(context).size.width > 420
                          ? 130
                          : 120,
                  height: MediaQuery.of(context).size.width < 370
                      ? 100
                      : MediaQuery.of(context).size.width > 420
                          ? 130
                          : 120,
                ),
                const SizedBox(width: 100),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    'Fingerlings Counter & Records',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Roboto Condensed',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width < 370
                          ? 20
                          : MediaQuery.of(context).size.width > 420
                              ? 30
                              : 22,
                      color: Colors.green[900],
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            // Main Title Column with Logo End

            // First Row Counter and History Start
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width < 370
                        ? 90
                        : MediaQuery.of(context).size.width > 420
                            ? 120
                            : 110,
                    height: MediaQuery.of(context).size.width < 370
                        ? 90
                        : MediaQuery.of(context).size.width > 420
                            ? 120
                            : 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFD3D3D3),
                      boxShadow: const [],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CounterScreen(), // Navigate to CounterScreen
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: MediaQuery.of(context).size.width < 370
                                ? 30
                                : MediaQuery.of(context).size.width > 420
                                    ? 50
                                    : 50,
                            color: Colors.green[900],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Counter',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontSize: MediaQuery.of(context).size.width < 430
                                  ? 13
                                  : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width < 370
                        ? 90
                        : MediaQuery.of(context).size.width > 420
                            ? 120
                            : 110,
                    height: MediaQuery.of(context).size.width < 370
                        ? 90
                        : MediaQuery.of(context).size.width > 420
                            ? 120
                            : 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFD3D3D3),
                      boxShadow: const [],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsTableScreen(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart,
                            size: MediaQuery.of(context).size.width < 370
                                ? 30
                                : MediaQuery.of(context).size.width > 420
                                    ? 50
                                    : 50,
                            color: Colors.green[900],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'History',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontSize: MediaQuery.of(context).size.width < 430
                                  ? 13
                                  : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // First Row Counter and History End

            //Second Row Sales and Exit Start
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width < 370
                      ? 90
                      : MediaQuery.of(context).size.width > 420
                          ? 120
                          : 110,
                  height: MediaQuery.of(context).size.width < 370
                      ? 90
                      : MediaQuery.of(context).size.width > 420
                          ? 120
                          : 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFD3D3D3),
                    boxShadow: const [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          size: MediaQuery.of(context).size.width < 370
                              ? 30
                              : MediaQuery.of(context).size.width > 420
                                  ? 50
                                  : 50,
                          color: Colors.green[900],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Sales',
                          style: GoogleFonts.getFont(
                            'Roboto Condensed',
                            fontSize: MediaQuery.of(context).size.width < 430
                                ? 13
                                : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width < 370
                      ? 90
                      : MediaQuery.of(context).size.width > 420
                          ? 120
                          : 110,
                  height: MediaQuery.of(context).size.width < 370
                      ? 90
                      : MediaQuery.of(context).size.width > 420
                          ? 120
                          : 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red[900],
                    boxShadow: const [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      exit(0);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left_rounded,
                          size: MediaQuery.of(context).size.width < 370
                              ? 30
                              : MediaQuery.of(context).size.width > 420
                                  ? 50
                                  : 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Exit',
                          style: GoogleFonts.getFont(
                            'Roboto Condensed',
                            fontSize: MediaQuery.of(context).size.width < 430
                                ? 13
                                : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //Second Row Sales and Exit End
          ],
        ),
      ),
    );
  }
}
