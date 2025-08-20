import 'dart:io';

import 'package:ets/model/employe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tensorflow_face_verification/tensorflow_face_verification.dart';
import 'dart:convert';
import 'face_detection_service.dart';
import 'face_embedding_service.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image_lib;

class FaceRecognitionService extends ChangeNotifier {
  final FaceEmbeddingService _faceEmbeddingService = FaceEmbeddingService();
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      _isInitialized = true;
      print('✅ Face Recognition Service fully initialized');
      notifyListeners();
      
    } catch (e) {
      print('❌ Failed to initialize Face Recognition Service: $e');
      throw Exception('Face Recognition initialization failed: $e');
    }
  }

Future<FaceRegistrationResult> registerFace({
  required Uint8List imageBytes,
  required String imagePath,
  required String employeeName,
  required String supervisorId,
  required String labourId,
}) async {
  if (!_isInitialized) {
    throw Exception('Face Recognition Service not initialized');
  }
    final faceService = FaceVerification.instance;
 
  try {
    // Step 1: Detect faces
         File? selectedImage = File(imagePath); 

    // Step 3: Extract cropped face region (returns image_lib.Image?)
    final faceRegion = await faceService.extractFaceRegion(selectedImage);

    if (faceRegion == null) {
      return FaceRegistrationResult(
        success: false,
        error: 'Failed to extract face region. Please try again.',
      );
    }

    // Step 4: Generate vector embedding of the face
    final embedding = await faceService.extractFaceEmbedding(faceRegion);

    if (embedding.isEmpty) {
      return FaceRegistrationResult(
        success: false,
        error: 'Failed to generate face embedding. Please try again.',
      );
    }

    // Step 5: Construct the employee object
    final employee = Employee(
      name: employeeName,
      supervisorId: supervisorId,
      labourId: labourId,
      faceEmbedding: jsonEncode(embedding),
      createdDate: DateTime.now(),
    );

    // Step 6: Return success result
    return FaceRegistrationResult(
      success: true,
      employee: employee,
      embedding: embedding,
      // faceImage: faceRegion,
    );
  } catch (e, stack) {
    print('❌ Face registration error: $e\n$stack');
    return FaceRegistrationResult(
      success: false,
      error: 'Registration failed: ${e.toString()}',
    );
  }
}
 
  Future<FaceRecognitionResult> recognizeFace({
  required Uint8List imageBytes,
  required String imagePath,
  required List<Employee> registeredEmployees,
}) async {
  if (!_isInitialized) {
    throw Exception('Face Recognition Service not initialized');
  }
    final faceService = FaceVerification.instance;

  try { 
    // Step 1: Detect faces
         File? selectedImage = File(imagePath); 

    // Step 3: Extract cropped face region (returns image_lib.Image?)
    final faceRegion = await faceService.extractFaceRegion(selectedImage);

    if (faceRegion == null) {
      return FaceRecognitionResult(
        success: false,
        message: 'Failed to extract face region. Please try again.',
      );
    }

    // Step 4: Generate vector embedding of the face
    final queryEmbedding = await faceService.extractFaceEmbedding(faceRegion);

    if (queryEmbedding.isEmpty) {
      return FaceRecognitionResult(
        success: false,
        message: 'Failed to generate face embedding. Please try again.',
      );
    }

    // Step 6: Prepare stored embeddings
    final storedEmbeddings = registeredEmployees
        .where((e) => e.faceEmbedding.isNotEmpty)
        .map((employee) {
          final decoded = jsonDecode(employee.faceEmbedding);
          if (decoded is List) {
            return StoredFaceEmbedding(
              embedding: List<double>.from(decoded),
              employeeData: employee,
            );
          } else {
            throw Exception('Invalid embedding format');
          }
        }).toList();

    // Step 7: Match embedding
    final matchResult = _faceEmbeddingService.findBestMatch(
      queryEmbedding,
      storedEmbeddings,
      faceService
    );

    // Log similarity and confidence
    print('✅ Similarity: ${matchResult.similarity}');
    print('✅ Confidence: ${matchResult.confidence}');
    print('✅ Is Match: ${matchResult.isMatch}');

    if (matchResult.isMatch) {
      return FaceRecognitionResult(
        success: true,
        message: 'Face recognized successfully',
        matchedEmployee: matchResult.matchedEmployee,
        confidence: matchResult.confidence,
        similarity: matchResult.similarity,
      );
    } else {
      return FaceRecognitionResult(
        success: false,
        message: 'Face not recognized',
        confidence: matchResult.confidence,
        similarity: matchResult.similarity,
      );
    }
  } catch (e, stack) {
    print('❌ Face recognition error: $e\n$stack');
    return FaceRecognitionResult(
      success: false,
      message: 'Recognition failed: ${e.toString()}',
    );
  }
}

  @override
  void dispose() {
    _faceEmbeddingService.dispose();
    _isInitialized = false;
    super.dispose();
  }
}

class FaceRegistrationResult {
  final bool success;
  final String? error;
  final Employee? employee;
  final List<double>? embedding;
  final Uint8List? faceImage;

  FaceRegistrationResult({
    required this.success,
    this.error,
    this.employee,
    this.embedding,
    this.faceImage,
  });
}

class FaceRecognitionResult {
  final bool success;
  final String message;
  final EmployeeDetails? matchedEmployee;
  final double confidence;
  final double similarity;

  FaceRecognitionResult({
    required this.success,
    required this.message,
    this.matchedEmployee,
    this.confidence = 0.0,
    this.similarity = 0.0,
  });
}