import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ScanAndPages extends StatefulWidget {
  const ScanAndPages({super.key});

  @override
  State<ScanAndPages> createState() => _ScanAndPagesState();
}

class _ScanAndPagesState extends State<ScanAndPages> {
  late CameraController _cameraController;
  bool _isProcessing = false;
  String _scannedText = '';
  String _translatedText = '';
  var originLanguage = 'From';
  var destinationLanguage = "To";
  List<CameraDescription> _cameras = [];
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize camera
  void _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {});
  }

  // Scan text using the camera
  Future<void> _scanText() async {
    if (_cameraController.value.isInitialized) {
      setState(() {
        _isProcessing = true;
      });

      try {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final textRecognizer = GoogleMlKit.vision.textRecognizer();
        final recognizedText = await textRecognizer.processImage(inputImage);
        setState(() {
          _scannedText = recognizedText.text;
          _isProcessing = false;
        });
        _translateText();
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
        _showError("Failed to scan text. Please try again.");
      }
    }
  }

  // Translate the scanned text
  void _translateText() async {
    if (_scannedText.isNotEmpty) {
      try {
        GoogleTranslator translator = GoogleTranslator();
        var translation = await translator.translate(_scannedText,
            from: getLanguageCode(originLanguage),
            to: getLanguageCode(destinationLanguage));
        setState(() {
          _translatedText = translation.text;
        });
      } catch (e) {
        _showError(
            "Failed to translate text. Please check your internet connection.");
      }
    }
  }

  String getLanguageCode(String language) {
    switch (language) {
      case "English":
        return "en";
      case "Hindi":
        return "hi";
      // ... other languages
      default:
        return '--';
    }
  }

  // Save translated text to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Translated text copied to clipboard!')),
    );
  }

  // Share translated text
  void _shareText() {
    if (_translatedText.isNotEmpty) {
      Share.share(_translatedText);
    } else {
      _showError("No text to share!");
    }
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan & Translate'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_cameraController.value.isInitialized)
              AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: Stack(
                  children: [
                    CameraPreview(_cameraController),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isProcessing) CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Scanned Text: $_scannedText", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: originLanguage,
              onChanged: (String? value) {
                setState(() {
                  originLanguage = value!;
                });
              },
              items: [
                'From',
                'English',
                // ... other languages
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: destinationLanguage,
              onChanged: (String? value) {
                setState(() {
                  destinationLanguage = value!;
                });
              },
              items: [
                'To',
                'Hindi',
                // ... other languages
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _scanText,
              child: Text('Scan Text'),
            ),
            SizedBox(height: 20),
            Text("Translated Text: $_translatedText",
                style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _copyToClipboard,
                  child: Text('Copy'),
                ),
                ElevatedButton(
                  onPressed: _shareText,
                  child: Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
