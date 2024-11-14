import 'dart:convert';

import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/repo/firebase_note_repo.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final firebaseNoteProvider = StateNotifierProvider<FirebaseNoteNotifier, AsyncValue<List<Note>>>((ref) {
  return FirebaseNoteNotifier(FirebaseNoteRepository());
});

class FirebaseNoteNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final FirebaseNoteRepository _repository;

  FirebaseNoteNotifier(this._repository) : super(const AsyncValue.data([])){}

  Future<void> loadNotes({String? id,required BuildContext context}) async {
    String? deviceId = id ?? await getDeviceId(context);
    state = const AsyncValue.loading();
    if(deviceId == null){
      state = AsyncValue.data([]);
    }
    else{
      try {
      final notes = await _repository.getNotes(deviceId);
      print(jsonEncode(notes));
      state = AsyncValue.data(notes);
    } catch (error) {
      state = AsyncValue.error("Something went wrong",StackTrace.current);
    }
    }
  }

}

