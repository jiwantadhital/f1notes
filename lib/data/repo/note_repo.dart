import 'package:f1notes/data/model/note.dart';
import 'package:hive/hive.dart';

class NoteRepository {
  final Box<Note> _noteBox = Hive.box<Note>('notes');

  List<Note> getNotes() => _noteBox.values.toList();

  Future<void> addNote(Note note) async {
    await _noteBox.add(note);
  }

  Future<void> deleteNoteAt(int index) async {
    await _noteBox.deleteAt(index);
  }

    Future<void> clearAllNotes() async {
    await _noteBox.clear();
      }

}
