import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/repo/firebase_note_repo.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final firebaseSearchNoteProvider = StateNotifierProvider<FirebaseSearchNoteNotifier, AsyncValue<List<Note>>>((ref) {
  return FirebaseSearchNoteNotifier(FirebaseNoteRepository());
});

class FirebaseSearchNoteNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final FirebaseNoteRepository _repository;

  FirebaseSearchNoteNotifier(this._repository) : super(const AsyncValue.data([])){}


  void clearNotes() {
    state = const AsyncValue.data([]);  
  }



  Future<void> loadFilteredNotes({String? searchText, DateTime? startDate, DateTime? endDate,required BuildContext context}) async {
    String? deviceId = await getDeviceId(context);
    state = const AsyncValue.loading();
    if(deviceId == null){
      state = AsyncValue.data([]);
    }
    else{
      try {
      final notes = await _repository.getFilteredNotes(deviceId,searchText: searchText,startDate: startDate,endDate: endDate);
      state = AsyncValue.data(notes);
    } catch (error) {
      state = AsyncValue.error("Something went wrong",StackTrace.current);
    }
    }
  }
  

}

