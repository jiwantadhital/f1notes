import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/provider/note_provider.dart';
import 'package:f1notes/resources/extracted_widgets/custom_button.dart';
import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:f1notes/resources/extracted_widgets/custom_textfield.dart';
import 'package:f1notes/screens/qr_screens/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNotesBottomSheet extends ConsumerStatefulWidget {
  const AddNotesBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNotesBottomSheet> createState() => _AddNotesBottomSheetState();
}

class _AddNotesBottomSheetState extends ConsumerState<AddNotesBottomSheet> {
  final key = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty";
    }
    return null;
  }

  void _addNote() {
    if (key.currentState!.validate()) {
      final note = Note(
        title: titleController.text,
        description: descController.text,
        addedDate: DateTime.now(),
      );
      ref.read(noteProvider.notifier).addAndGetNotes(note).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return IntrinsicHeight(
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Form(
          key: key,
          child: Column(
            children: [
              CustomText(
                text: "Add Notes",
                fontSize: 20,
                weight: FontWeight.bold,
              ),
              SizedBox(height: size.height * 0.05),
              // Title Field
              CustomTextField(
                hintText: "Title",
                controller: titleController,
                validator: (v) => _validateField(v, "Title"),
              ),
              SizedBox(height: size.height * 0.03),
              // Description Field
              CustomTextField(
                hintText: "Description",
                controller: descController,
                maxLines: 5,
                contentPadding: EdgeInsets.all(8),
                keyboardType: TextInputType.multiline,
                validator: (v) => _validateField(v, "Description"),
              ),
              SizedBox(height: size.height * 0.05),
              // Buttons Row
              _buildButtons(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Add Notes Button
        Container(
          width: size.width * 0.70,
          child: CustomButton(
            text: "Add Notes",
            onPress: _addNote,
          ),
        ),
        // QR Code Button
        Container(
          width: size.width * 0.18,
          child: CustomButton(
            icon: Icons.qr_code_2_rounded,
            border: 20.0,
            onPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QrScannerPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}
