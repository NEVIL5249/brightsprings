import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MoodDetectionScreen extends StatefulWidget {
  const MoodDetectionScreen({Key? key}) : super(key: key);

  @override
  State<MoodDetectionScreen> createState() => _MoodDetectionScreenState();
}

class _MoodDetectionScreenState extends State<MoodDetectionScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  String _mood = "Detecting...";
  bool _isDetecting = false;
  bool _isInitialized = false;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      
      _cameraController = CameraController(
        frontCamera, 
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _startPeriodicDetection();
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
      if (mounted) {
        setState(() {
          _mood = "Camera error: $e";
        });
      }
    }
  }

  void _startPeriodicDetection() {
    // Capture and analyze image every 500ms instead of using image stream
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isDetecting || !_isInitialized || _cameraController == null) return;
      _captureAndAnalyze();
    });
  }

  Future<void> _captureAndAnalyze() async {
    if (_isDetecting || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _isDetecting = true;

    try {
      // Take a picture instead of using image stream
      final XFile imageFile = await _cameraController!.takePicture();
      final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
      
      final faces = await _faceDetector.processImage(inputImage);
      
      if (mounted) {
        if (faces.isNotEmpty) {
          final face = faces.first;
          String newMood;
          
          if (face.smilingProbability != null) {
            final smileProb = face.smilingProbability!;
            debugPrint("Smile probability: $smileProb");
            
            if (smileProb > 0.7) {
              newMood = "😊 Happy (${(smileProb * 100).toInt()}%)";
            } else if (smileProb > 0.3) {
              newMood = "😐 Neutral (${(smileProb * 100).toInt()}%)";
            } else {
              newMood = "😞 Sad (${(smileProb * 100).toInt()}%)";
            }
          } else {
            newMood = "😊 Face detected (no smile data)";
          }
          
          setState(() => _mood = newMood);
        } else {
          setState(() => _mood = "No face detected");
        }
      }
    } catch (e) {
      debugPrint("Error in face detection: $e");
      if (mounted) {
        setState(() => _mood = "Detection error: ${e.toString().substring(0, 50)}...");
      }
    }

    _isDetecting = false;
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mood Detection"),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isInitialized && 
                   _cameraController != null &&
                   _cameraController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "Initializing camera...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Current Mood:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _mood,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Detection updates every 0.5 seconds",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}