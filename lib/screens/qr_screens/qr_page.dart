import 'dart:convert';
import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/provider/note_provider.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:f1notes/resources/extracted_widgets/inkwell.dart';
import 'package:f1notes/screens/qr_screens/scanner_parts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  late MobileScannerController controller;
  Barcode? result;
  String? resultCode;
  bool flashStatus = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void stopCamera() {
    controller.stop();
    setState(() {});
  }

  void resumeCamera() {
    controller.start();
    setState(() {});
  }

  void _onQRViewCreated(BarcodeCapture qrData) {
    setState(() {
      resultCode = qrData.barcodes.first.displayValue;
    });
    _processQrData();
  }

  Future<void> _processQrData() async {
    stopCamera();
    try {
      if (resultCode != null && resultCode!.contains("title") && resultCode!.contains("description")) {
        var note = Note.fromJson(jsonDecode(resultCode!));
        ref.read(noteProvider.notifier).addAndGetNotes(note);
        Navigator.pop(context);
      } else {
        _showToast("Invalid QR", Colors.red);
        resumeCamera();
      }
    } catch (e) {
      _showToast("Something went wrong", Colors.red);
      resumeCamera();
    }
  }

  void _showToast(String message, Color color) {
    getToast(text: message, color: color);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: MobileScanner(
                controller: controller,
                overlayBuilder: (context, constraints) => OverlayWithRectangleClipping(),
                errorBuilder: (context, error, child) => ScannerErrorWidget(error: error),
                fit: BoxFit.cover,
                onDetect: _onQRViewCreated,
              ),
            ),
            _topFlashbackSection(size),
          ],
        ),
      ),
    );
  }

  Widget _topFlashbackSection(Size size) {
    return Positioned(
      top: 0,
      left: 30,
      right: 30,
      child: SafeArea(
        child: Container(
          height: 40,
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWellWithDelay(
                onTap: () => Navigator.pop(context),
                child: _buildIcon(Icons.arrow_back_ios),
              ),
              GestureDetector(
                onTap: () => _toggleFlash(),
                child: _buildIcon(flashStatus ? Icons.flash_on_outlined : Icons.flash_off),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      height: 30,
      width: 30,
      child: Icon(icon, color: Colors.white),
    );
  }

  void _toggleFlash() async {
    controller.toggleTorch().then((value) {
      setState(() {
        flashStatus = !flashStatus;
      });
    });
  }
}

