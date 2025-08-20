import 'dart:io';
import 'package:ets/dynamic_widget/dropdown_button.dart';
import 'package:ets/provider/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CameraDropdownScreen extends StatefulWidget {
  const CameraDropdownScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraDropdownScreenState createState() => _CameraDropdownScreenState();
}

class _CameraDropdownScreenState extends State<CameraDropdownScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraInitialized = false;
  String? _recognizedEmployee;
  String? selectedValue;
  final List<Map<String, dynamic>> dropdownItems = [
    {
      "_id": "TASK041",
      "name": "Roofing",
      "project_id": "LLY2F",
      "task_owner": "d3a900f2daf34223b960c66a82bd634d",
      "building_name": "HK1",
      "created_on": {"\$date": "2025-08-02T09:50:56.553Z"},
      "created_by": "sanjay",
      "type": "TASK",
      "status": "assigned",
      "update_by": "sanjay",
      "update_on": {"\$date": "2025-08-11T08:09:11.239Z"}
    },
    {
      "_id": "ACTIVITY025",
      "priority": "medium",
      "created_on": {"\$date": "2025-08-06T08:09:29.565Z"},
      "name": "painting",
      "type": "ACTIVITY",
      "parent_id": "TASK041",
      "project_id": "LLY2F",
      "status": "assigned",
      "created_by": "sanjay",
      "task_status": "OPEN",
      "activity_type": "c698ff6a32a34371acf53c6a9313fc7c",
      "schedule_start_date": {"\$date": "2025-08-07T18:30:00.000Z"},
      "task_owner": "a8f73a41e1374a6f889d8da33d5bffab"
    },
    {
      "_id": "ACTIVITY026",
      "name": "Basement Pillar",
      "task_status": "OPEN",
      "type": "ACTIVITY",
      "parent_id": "TASK036",
      "activity_type": "fc650582-6d46-42b5-8f96-d3bc6a6526c0",
      "schedule_start_date": {"\$date": "2025-08-09T18:30:00.000Z"},
      "priority": "medium",
      "project_id": "LLOYDS",
      "task_owner": "7e04c32238184792ba09891eb1924154",
      "status": "assigned",
      "created_on": {"\$date": "2025-08-06T09:50:28.689Z"},
      "created_by": "sanjay"
    },
    {
      "_id": "TASK045",
      "project_id": "LLOYDS",
      "type": "TASK",
      "created_on": {"\$date": "2025-08-11T13:02:43.227Z"},
      "task_owner": "06378cfc09194a05ac9b39a5f997556b",
      "building_name": "Block D",
      "status": "assigned",
      "created_by": "sanjay",
      "name": "Structural Work"
    },
    {
      "_id": "ACTIVITY028",
      "activity_type": "6bda49c0-1ff5-4e52-bf98-2d8e24870c4a",
      "task_owner": "782eb96fd63e43eeaacd7a9925fd0c7a",
      "created_on": {"\$date": "2025-08-11T13:03:08.559Z"},
      "created_by": "sanjay",
      "name": "Steel Reinforcement",
      "task_status": "OPEN",
      "schedule_start_date": {"\$date": "2025-08-19T18:30:00.000Z"},
      "status": "assigned",
      "type": "ACTIVITY",
      "parent_id": "TASK045",
      "project_id": "LLOYDS"
    },
    {
      "_id": "ACTIVITY029",
      "type": "ACTIVITY",
      "parent_id": "TASK041",
      "task_owner": "4e90976a378348d0b3bf34d2f44398cd",
      "status": "assigned",
      "created_by": "sanjay",
      "name": "constructing divider",
      "task_status": "OPEN",
      "project_id": "LLY2F",
      "activity_type": "a3028340-c338-4ed3-8c35-3f0a47eaf9fc",
      "schedule_start_date": {"\$date": "2025-08-12T18:30:00.000Z"},
      "priority": "low",
      "created_on": {"\$date": "2025-08-11T13:32:48.638Z"}
    }
  ];

  // Extra states
  late FaceDetector _faceDetector;
  late SpeechToText _speech;
  bool _isLoading = false;
  String? _statusMessage;
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
Future<void> _toggleCamera() async {
    if (!_isCameraInitialized) return;
      final cameraService = context.read<CameraService>();
       await cameraService.switchCamera();
  }
  Future<void> _recognizeFace() async {
    if (!_isCameraInitialized) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Capturing image...';
    });

    try {
     final cameraService = context.read<CameraService>();
final CapturedImage? capturedImage = await cameraService.takePicture();

if (capturedImage == null) {
  throw Exception('Failed to capture image');
}

// imageBytes is already available
final Uint8List imageBytes = capturedImage.bytes;
final String imagePath = capturedImage.path;

print('📂 Image Path: $imagePath');

setState(() {
  _statusMessage = 'Verifying image...';
});
 
      // Verify image quality and face presence
      final isValid = await _verifyImage(imageBytes,imagePath);
      if (!isValid) {
        throw Exception('Image verification failed. Please try again with better lighting and face positioning.');
      }

      setState(() {
        _statusMessage = 'Recognizing face...';
      });
      
      final faceService = context.read<FaceRecognitionService>();
      
      // Load registered employees from database
      final registeredEmployees = <Employee>[];
      try {
        final employees = await DatabaseService.getAllEmployees();
        registeredEmployees.addAll(employees);
      } catch (e) {
        print('Error loading employees: $e');
      }
      
      final result = await faceService.recognizeFace(
        imageBytes: imageBytes,
        imagePath:imagePath,
        registeredEmployees: registeredEmployees,
      );

      if (result.success && result.matchedEmployee != null) {
        setState(() {
          _recognizedEmployee = result.matchedEmployee!.name;
          _confidence = result.confidence;
          _statusMessage = 'Face recognized successfully!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${result.matchedEmployee!.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _recognizedEmployee = null;
          _confidence = result.confidence;
          _statusMessage = result.message;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.orange,
          ),
        );
      }

    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _verifyImage(Uint8List imageBytes,String imagePath) async {
    try { 
      // Use face detection service to verify face presence
      final faceDetectionService = FaceDetectionService();
      await faceDetectionService.initialize();
          final inputImage = InputImage.fromFilePath(imagePath);

      final faces = await faceDetectionService.detectFaces(inputImage);
      
      return faces.isNotEmpty;
    } catch (e) {
      return false;
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
      appBar: AppBar(title: Text("Dynamic View")),
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
                            Expanded(
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: _buildCameraPreview(),
                              ),
                            ),
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
           if (_recognizedEmployee != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48.w,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _recognizedEmployee!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Confidence: ${_confidence.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
          // Bottom half: Dropdown or captured image
          Expanded(
            flex: 1,
            child: Center(
              child: _capturedPath == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropDownButtonwidgetMap(
                        isrequired: true,
                        hintText: "Select Task",
                        listArrayValues: dropdownItems,
                        isImageRequired: false,
                      ),
                    )
                  : Image.file(File(_capturedPath!)),
            ),
          ),
        ],
      ),
    );
  }
   Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    final cameraService = context.watch<CameraService>();
    
    if (!cameraService.isCameraReady || cameraService.controller == null) {
      return Center(
        child: Text(
          'Camera not ready',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CameraPreview(cameraService.controller!),
    );
  }
}


