import 'dart:async';
import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/data/provider/note_provider.dart';
import 'package:f1notes/data/repo/sync_repo.dart';
import 'package:f1notes/firebase_options.dart';
import 'package:f1notes/screens/note_lists/notes_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Hive.initFlutter(),
  ]);
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'F1 Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerWidget(),
    );
  }
}

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget> {
  final SyncService syncService = SyncService();
  Timer? _syncTimer;
  @override
  void initState() {
    super.initState();
    _startSyncTimer();
  }

  void _startSyncTimer() {
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      ref.read(noteProvider.notifier).syncService(ref, context);
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  NotesList();
  }
}
