import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'db/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomeScreen.dart';
import 'CounterScreen.dart';


class ResultsScreen extends StatefulWidget {
  final List<File> images;
  final List<List<ResultObjectDetection?>> objDetectResults;
  final ModelObjectDetection objectModel;
  final bool averagingMode;

  const ResultsScreen({
    super.key,
    required this.images,
    required this.objDetectResults,
    required this.objectModel,
    required this.averagingMode,
  });

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int _currentImageIndex = 0;
  final TextEditingController _batchNumberController = TextEditingController();
  double? averageDetectedObjects;

  @override
  void dispose() {
    _batchNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.averagingMode) {
      averageDetectedObjects = widget.objDetectResults
              .map((result) => result.length)
              .reduce((a, b) => a + b) /
          widget.objDetectResults.length;
    }
  }

  Future<bool> checkBatchNumberExists(int batchNumber) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'results',
      where: 'batch_number = ?',
      whereArgs: [batchNumber],
    );
    return result.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    int totalDetectedObjects =
        widget.objDetectResults[_currentImageIndex].length;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFF5E1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width < 370
                        ? 10
                        : MediaQuery.of(context).size.width > 420
                            ? 20
                            : 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.green[900],
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
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'FINGERLINGS COUNTER',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width < 370
                              ? 20
                              : MediaQuery.of(context).size.width > 420
                                  ? 25
                                  : 20,
                          color: Colors.green[900],
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Expanded widget for object detection results
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.4, // Adjust the height as per your UI
                  child: Stack(
                    children: [
                      widget.objectModel.renderBoxesOnImage(
                        widget.images[_currentImageIndex],
                        widget.objDetectResults[_currentImageIndex],
                      ),
                      CustomPaint(
                        size: Size.infinite,
                        painter: GridPainter(
                          numHorizontalLines: 2,
                          numVerticalLines: 2,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Detected Objects: $totalDetectedObjects',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width < 370
                        ? 15
                        : MediaQuery.of(context).size.width > 420
                            ? 25
                            : 18,
                    color: Colors.green[900],
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),

                // TextFormField for averageDetectedObjects
                if (widget.averagingMode && averageDetectedObjects != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      initialValue: averageDetectedObjects!.toStringAsFixed(0),
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Average Detected Objects',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // TextFormField for batch number
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _batchNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Batch Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                widget.averagingMode && widget.images.length > 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentImageIndex > 0)
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  _currentImageIndex--;
                                });
                              },
                            ),
                          Text(
                              '${_currentImageIndex + 1} / ${widget.images.length}'),
                          if (_currentImageIndex < widget.images.length - 1)
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                setState(() {
                                  _currentImageIndex++;
                                });
                              },
                            ),
                        ],
                      )
                    : Container(),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        int batchNumber =
                            int.tryParse(_batchNumberController.text) ?? 0;

                        bool exists = await checkBatchNumberExists(batchNumber);

                        if (exists) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text(
                                    "Batch number already exists. Please try again."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          int detectedCount = widget.averagingMode &&
                                  averageDetectedObjects != null
                              ? averageDetectedObjects!.round()
                              : totalDetectedObjects;

                          await DatabaseHelper.instance.insertResult({
                            'batch_number': batchNumber,
                            'total_count': detectedCount,
                          });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Success"),
                                content: const Text("Data successfully saved."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      icon: Icon(Icons.save_alt, color: Colors.green[900]),
                      label: Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 20), // Add spacing between the buttons
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const HomeScreen()),
                    //       (route) => false,
                    //     );
                    //   },
                    //   icon: Icon(Icons.arrow_back, color: Colors.green[900]),
                    //   label: Text(
                    //     "BACK",
                    //     style: TextStyle(
                    //       color: Colors.green[900],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int numHorizontalLines;
  final int numVerticalLines;
  final Color color;

  GridPainter({
    required this.numHorizontalLines,
    required this.numVerticalLines,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double stepX = size.width / numVerticalLines;
    double stepY = size.height / numHorizontalLines;

    // Draw vertical lines
    for (int i = 0; i <= numVerticalLines; i++) {
      double x = stepX * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (int i = 0; i <= numHorizontalLines; i++) {
      double y = stepY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
