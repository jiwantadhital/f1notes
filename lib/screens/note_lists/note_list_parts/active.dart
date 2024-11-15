import 'package:f1notes/data/provider/firebase_note_provider.dart';
import 'package:f1notes/resources/extracted_widgets/custom_button.dart';
import 'package:f1notes/resources/extracted_widgets/empty_retry/empty.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/note_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f1notes/data/model/note.dart';

class ActiveTabData extends StatelessWidget {
  final WidgetRef ref;
  final AsyncValue<List<Note>> localNoteData;
  final AsyncValue<List<Note>> firebaseNoteData;

  const ActiveTabData({
    Key? key,
    required this.ref,
    required this.localNoteData,
    required this.firebaseNoteData,
  }) : super(key: key);

  List<Note> _filterActiveNotes(List<Note> notes) {
    return notes.where((note) => note.dueDate.isAfter(DateTime.now())).toList();
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildErrorMessage(String error) {
    return Center(child: Text('Failed to load notes: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocalNotesSection(),
          _buildFirebaseNotesSection(context),
        ],
      ),
    );
  }

  //local notes section.
  Widget _buildLocalNotesSection() {
    return localNoteData.when(
      data: (notes) {
        final noteList = _filterActiveNotes(notes);
        return  NotesListBuilder(
                isFirebase: false,
                notes: noteList,
                ref: ref,
              );
      },
      error: (error, stack) => _buildErrorMessage(error.toString()),
      loading: _buildLoadingIndicator,
    );
  }

  //synced firebase notes section.
  Widget _buildFirebaseNotesSection(BuildContext context) {
    return firebaseNoteData.when(
      data: (notes) {
        final noteList = _filterActiveNotes(notes);
        if (notes.isEmpty) {
          return _buildSyncedNotesEmptyState(context);
        } else {
          if(noteList.isEmpty){
            return Center(
              child: EmptyData(text: "No Synced Active Data"),
            );
          }
          else{
            return NotesListBuilder(
                notes: noteList,
                ref: ref,
              );
          }
        }
      },
      error: (error, stackTrace) => _buildErrorMessage(error.toString()),
      loading: _buildLoadingIndicator,
    );
  }

  //"Load Synced Data".
  Widget _buildSyncedNotesEmptyState(BuildContext context) {
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
  }
}
