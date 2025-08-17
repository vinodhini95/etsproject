import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CameraDropdownScreen extends StatefulWidget {
  @override
  _CameraDropdownScreenState createState() => _CameraDropdownScreenState();
}

class _CameraDropdownScreenState extends State<CameraDropdownScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? selectedValue;
  final List<String> dropdownItems = ["Option 1", "Option 2", "Option 3"];

  // Extra states
  late FaceDetector _faceDetector;
  late SpeechToText _speech;
  bool _cheeseSaid = false;
  bool _isDetecting = false;
  String? _capturedPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initFaceDetector();
    _initSpeech();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();

    await _initializeControllerFuture;

    // start image stream
    _controller!.startImageStream((image) {
      if (!_isDetecting && _cheeseSaid) {
        _isDetecting = true;
        _processCameraImage(image);
      }
    });

    if (mounted) setState(() {});
  }

  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableClassification: true),
    );
  }

  void _initSpeech() async {
    _speech = SpeechToText();
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (res) {
        if (res.recognizedWords.toLowerCase().contains("cheese")) {
          setState(() => _cheeseSaid = true);
        }
      });
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      // Convert CameraImage → InputImage
      final WriteBuffer allBytes = WriteBuffer();
      for (var plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(image.width.toDouble(), image.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotation.rotation0deg; // adjust if needed

      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
              InputImageFormat.nv21;

      // ✅ Only the new API (no InputImagePlaneMetadata / InputImageData)
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes.first.bytesPerRow, // required now
        ),
      );

      // Detect faces
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;

        final leftEye = face.leftEyeOpenProbability ?? 1.0;
        final rightEye = face.rightEyeOpenProbability ?? 1.0;

        // Blink detection
        if (leftEye < 0.3 && rightEye < 0.3) {
          await _captureImage();
        }
      }
    } catch (e) {
      print("Face detection error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _captureImage() async {
    try {
      if (!_controller!.value.isInitialized) return;

      final file = await _controller!.takePicture();
      setState(() {
        _capturedPath = file.path;
      });
    } catch (e) {
      print("Capture error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text( "Dynamic View")),
      body: Column(
        children: [
          // Top half: Camera preview
          Expanded(
            flex: 1,
            child: _controller == null
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          children: [
                            CameraPreview(_controller!),
                            if (_cheeseSaid)
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.red, width: 3),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),

          // Bottom half: Dropdown or captured image
          Expanded(
            flex: 1,
            child: Center(
              child: _capturedPath == null
                  ? DropdownButton<String>(
                      value: selectedValue,
                      hint: Text("Select an option"),
                      items: dropdownItems.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    )
                  : Image.file(File(_capturedPath!)),
            ),
          ),
        ],
      ),
    );
  }
}
