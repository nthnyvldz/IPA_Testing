import 'package:counter/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'results_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  ModelObjectDetection? _objectModel; // Made nullable
  ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  List<List<ResultObjectDetection?>> _objDetectResults = [];
  bool averagingMode = false;
  bool isLoading = false;
  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/fish.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
        pathObjectDetectionModel,
        1,
        640,
        640,
        labelPath: "assets/labels/labels.txt",
      );
      setState(() {
        modelLoaded = true;
      });
    } catch (e) {
      print("Error loading model: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Model Load Error"),
            content: Text("Failed to load model: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future runObjectDetection(ImageSource source) async {
    if (_objectModel == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Model is not loaded yet. Please try again later."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      var objDetect = await _objectModel!.getImagePrediction(
        await File(image.path).readAsBytes(),
        minimumScore: 0.3,
        IOUThershold: 0.2,
        boxesLimit: 10000,
      );

      setState(() {
        _images.add(File(image.path));
        _objDetectResults.add(objDetect);
        isLoading = false;
      });

      if (averagingMode) {
        if (_images.length < 5) {
          runObjectDetection(ImageSource.camera);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                images: _images,
                objDetectResults: _objDetectResults,
                objectModel: _objectModel!,
                averagingMode: averagingMode,
              ),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              images: [_images.last],
              objDetectResults: [_objDetectResults.last],
              objectModel: _objectModel!,
              averagingMode: averagingMode,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showPicker(BuildContext context) {
    if (!modelLoaded) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Model Not Loaded"),
            content: Text("Please wait until the model is loaded."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (!averagingMode) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    runObjectDetection(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    runObjectDetection(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      runObjectDetection(ImageSource.camera);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[900]),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen(), // Navigate to CounterScreen
            ),
          ),
          iconSize: 25,
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width < 370
                        ? 120
                        : MediaQuery.of(context).size.width > 420
                            ? 180
                            : 160,
                    height: MediaQuery.of(context).size.width < 370
                        ? 120
                        : MediaQuery.of(context).size.width > 420
                            ? 180
                            : 160,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fingerlings Counter and Records',
                    style: GoogleFonts.getFont(
                      'Roboto Condensed',
                      fontSize: MediaQuery.of(context).size.width < 370
                          ? 20
                          : MediaQuery.of(context).size.width > 420
                              ? 30
                              : 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      _showPicker(context);
                    },
                    child: Text(averagingMode
                        ? 'Taking Images via Camera'
                        : 'Take/Select Image'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Average Mode:',
                        style: GoogleFonts.getFont(
                          'Roboto Condensed',
                          fontSize: MediaQuery.of(context).size.width < 370
                              ? 20
                              : MediaQuery.of(context).size.width > 420
                                  ? 30
                                  : 25,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Switch(
                        value: averagingMode,
                        onChanged: (value) {
                          setState(() {
                            averagingMode = value;
                            if (!averagingMode) {
                              _images.clear();
                              _objDetectResults.clear();
                            }
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
