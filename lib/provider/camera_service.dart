import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';
class CapturedImage {
  final String path;
  final Uint8List bytes;

  CapturedImage({required this.path, required this.bytes});
}

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCameraReady = false;
  String? _error;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isCameraReady => _isCameraReady;
  String? get error => _error;
  List<CameraDescription> get cameras => _cameras;
  CameraDescription? get selectedCamera => 
    _cameras.isNotEmpty ? _cameras[_selectedCameraIndex] : null;

  Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras.isEmpty) {
        throw Exception('No cameras available on this device');
      }

      _selectedCameraIndex = _cameras.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      
      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex = 0;
      }

      print('✅ Found ${_cameras.length} camera(s)');
      print('📹 Selected camera: ${selectedCamera?.name}');
      
      await _initializeController();
      
    } catch (e) {
      _error = 'Camera initialization failed: $e';
      print('❌ $_error');
      notifyListeners();
    }
  }

  Future<void> _initializeController() async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final camera = selectedCamera;
    if (camera == null) return;

    try {
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.yuv420 
          : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      
      if (Platform.isAndroid) {
        await _controller!.setFlashMode(FlashMode.off);
        await _controller!.setFocusMode(FocusMode.auto);
        await _controller!.setExposureMode(ExposureMode.auto);
      }

      _isInitialized = true;
      _isCameraReady = true;
      _error = null;
      
      print('✅ Camera controller initialized successfully');
      notifyListeners();
      
    } catch (e) {
      _error = 'Failed to initialize camera controller: $e';
      _isInitialized = false;
      _isCameraReady = false;
      print('❌ $_error');
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeController();
  }

  // Future<XFile?> takePicture() async {
  //   if (!_isCameraReady || _controller == null) {
  //     throw Exception('Camera not ready');
  //   }

  //   try {
  //     final image = await _controller!.takePicture();
  //     print('📸 Picture taken: ${image.path}');
  //     return image;
  //   } catch (e) {
  //     print('❌ Error taking picture: $e');
  //     return null;
  //   }
  // }
Future<CapturedImage?> takePicture() async {
  if (!_isCameraReady || _controller == null) {
    throw Exception('Camera not ready');
  }

  try {
    final XFile image = await _controller!.takePicture();
    final Uint8List imageBytes = await image.readAsBytes();

    print('📸 Picture taken: ${image.path}');

    return CapturedImage(
      path: image.path,
      bytes: imageBytes,
    );
  } catch (e) {
    print('❌ Error taking picture: $e');
    return null;
  }
}

  void startImageStream(void Function(CameraImage) onImage) {
    if (!_isCameraReady || _controller == null) return;

    try {
      _controller!.startImageStream(onImage);
      print('🎥 Image stream started');
    } catch (e) {
      print('❌ Error starting image stream: $e');
    }
  }

  Future<void> stopImageStream() async {
    if (_controller == null) return;

    try {
      await _controller!.stopImageStream();
      print('🎥 Image stream stopped');
    } catch (e) {
      print('❌ Error stopping image stream: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
    _isCameraReady = false;
    print('🧹 Camera Service disposed');
    super.dispose();
  }
}