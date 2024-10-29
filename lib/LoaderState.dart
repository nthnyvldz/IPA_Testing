import 'package:flutter/material.dart';
import 'dart:async';
import 'package:counter/HomeScreen.dart';

class LoaderState extends StatefulWidget {
  const LoaderState({super.key});

  @override
  State<LoaderState> createState() => _LoaderStateState();
}

class _LoaderStateState extends State<LoaderState> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width < 370
                  ? 140
                  : MediaQuery.of(context).size.width > 420
                      ? 180
                      : 160,
              height: MediaQuery.of(context).size.width < 370
                  ? 140
                  : MediaQuery.of(context).size.width > 420
                      ? 180
                      : 160,
            ),
            // const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            //   child: Center(
            //     child: Text(
            //       'Fingerlings Counter & Records',
            //       style: GoogleFonts.getFont(
            //         'Roboto Condensed',
            //         fontWeight: FontWeight.bold,
            //         fontSize: MediaQuery.of(context).size.width < 370
            //             ? 20
            //             : MediaQuery.of(context).size.width > 420
            //                 ? 30
            //                 : 25,
            //         color: Colors.green[900],
            //         decoration: TextDecoration.none,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
