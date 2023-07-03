import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  FlutterMidi flutterMidi = FlutterMidi();
  @override
  void initState() {
    load('assets/Guitars.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: _byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  String? choice;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: const Text(
            "Piano",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            DropdownButton(
                value: choice ?? "Geuiter",
                items: const [
                  DropdownMenuItem(
                      child: Text("Yamaha-Grand.sf2"), value: "Yamaha-Grand"),
                  DropdownMenuItem(
                    child: Text("Geuiter"),
                    value: "Geuiter",
                  ),
                  DropdownMenuItem(
                    child: Text("String"),
                    value: 'String',
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    choice = value;
                    load('assets/$choice.sf2');
                  });
                })
          ],
        ),
        body: CupertinoApp(
            title: 'Piano Demo',
            home: Center(
              child: InteractivePiano(
                highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: 60,
                noteRange: NoteRange.forClefs([
                  Clef.Bass,
                ]),
                onNotePositionTapped: (position) {
                  // Use an audio library like flutter_midi to play the sound
                  flutterMidi.playMidiNote(midi: position.pitch);
                },
              ),
            )));
  }
}
