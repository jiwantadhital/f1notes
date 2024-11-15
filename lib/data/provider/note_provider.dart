import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/repo/note_repo.dart';
import 'package:f1notes/data/repo/sync_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final noteProvider = StateNotifierProvider<NoteNotifier, AsyncValue<List<Note>>>((ref) {
  return NoteNotifier(NoteRepository(),SyncService());
});

class NoteNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository _repository;
  final SyncService _syncRepository;

  NoteNotifier(this._repository,this._syncRepository) : super(const AsyncValue.loading()){
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes =  _repository.getNotes();
      state = AsyncValue.data(notes);
    } catch (error) {
      state = AsyncValue.error(error.toString(),StackTrace.current);
    }
  }
  

  Future<void> addAndGetNotes(Note note) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addNote(note);
      _loadNotes();
    } catch (error) {
      state = AsyncValue.error("Something went wrong",StackTrace.current);
    }
  }

  Future<void> deleteAndGetNotes(int index) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteNoteAt(index);
      _loadNotes();
    } catch (error) {
      state = AsyncValue.error("Something went wrong",StackTrace.current);
    }
  }

  Future<void> syncService(WidgetRef ref,BuildContext context) async {
    try {
      await _syncRepository.syncNotes(ref,context);
    state = const AsyncValue.loading();
      _loadNotes();
    } catch (error) {
      state = AsyncValue.error(error.toString(),StackTrace.current);
    }
  }
  

}

