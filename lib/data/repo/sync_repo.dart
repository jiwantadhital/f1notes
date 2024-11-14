import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/provider/firebase_note_provider.dart';
import 'package:f1notes/data/repo/note_repo.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class SyncService {
  final NoteRepository noteRepository = NoteRepository();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final LocalAuthentication auth = LocalAuthentication();

  List<int> attempt = [];

  

  Future<void> syncNotes(WidgetRef ref,BuildContext context) async {
    attempt.add(1);
  if(attempt.length > 1){

  }
  else{
    List<Note> notes = noteRepository.getNotes();
  if (notes.isEmpty) {
    return;
  }

  String? deviceId = await getDeviceId(context);

  if(deviceId == null){
    attempt.clear();
  }
  else{
    String dId = deviceId;
    List<Map<String, dynamic>> newNotesData = notes.map((note) => note.toMap()).toList();

  try {
    DocumentSnapshot document = await firestore.collection('notes').doc(deviceId).get();
    List<Map<String, dynamic>> existingNotesData = [];

    if (document.exists) {
      List<dynamic> firebaseNotes = document['notes'];
      existingNotesData = firebaseNotes.map((note) => Map<String, dynamic>.from(note)).toList();
    }

    List<Map<String, dynamic>> combinedNotesData = [...existingNotesData, ...newNotesData];

    await firestore.collection('notes').doc(dId).set({
      'notes': combinedNotesData,
      'lastSynced': Timestamp.now(),
    },SetOptions(merge: true));

    await noteRepository.clearAllNotes().then((value) async{
      ref.read(firebaseNoteProvider.notifier).loadNotes(id: dId,context: context);
      attempt.clear();
      getToast(text: "Notes synced successfully!");
    });
  } catch (e) {
  }
  }
  }
}

}
