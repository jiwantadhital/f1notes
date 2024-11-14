import 'package:f1notes/data/provider/firebase_note_provider.dart';
import 'package:f1notes/resources/extracted_widgets/custom_button.dart';
import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:f1notes/resources/extracted_widgets/empty_retry/empty.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/note_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:f1notes/data/model/note.dart';

class ExpiredTabData extends StatelessWidget {
  final WidgetRef ref;
  final AsyncValue<List<Note>> localNoteData;
  final AsyncValue<List<Note>> firebaseNoteData;

  const ExpiredTabData({
    Key? key,
    required this.ref,
    required this.localNoteData,
    required this.firebaseNoteData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotesSection(localNoteData, isFirebase: false,context: context),
          _buildNotesSection(firebaseNoteData, isFirebase: true,context:  context),
        ],
      ),
    );
  }

  Widget _buildNotesSection(AsyncValue<List<Note>> noteData, {required bool isFirebase, required BuildContext context}) {
    return noteData.when(
      data: (notes) {
        final expiredNotes = notes
            .where((note) => note.dueDate.isBefore(DateTime.now()))
            .toList();

        if (notes.isEmpty && isFirebase) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                text: "Load Synced Data",
                onPress: () {
                  ref.read(firebaseNoteProvider.notifier).loadNotes(context: context);
                },
              ),
            ],
          );
        } else {
          if(expiredNotes.isEmpty && isFirebase){
            return Center(child: EmptyData(text: "No Synced Expired Notes"));
          }
          else{
            return NotesListBuilder(
            notes: expiredNotes,
            ref: ref,
            isFirebase: isFirebase,
          );
          }
          
        }
      },
      error: (err, stack) {
        return Center(
          child: Text("Error: $err"),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
