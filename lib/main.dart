import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? choice;
  Uri? link;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      home: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: DropdownButton<String?>(
                  value: choice ?? "Geuiter",
                  items: const [
                    DropdownMenuItem(
                        child: Text("Grand"), value: "Yamaha-Grand"),
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
                  }),
            ),
            backgroundColor: Colors.grey[200],
            leadingWidth: 100,
            title: const Text(
              "Piano",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    link = Uri.parse("tel:+972592729310");
                    launchUrl(link!);
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.black,
                    size: 20,
                  )),
              IconButton(
                  onPressed: () {
                    link = Uri.parse("sms:+972592729310");
                    launchUrl(link!, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(
                    Icons.sms,
                    color: Colors.black,
                    size: 20,
                  )),
              IconButton(
                  onPressed: () {
                    link = Uri.parse("mailto:bisaqwi06@gmail.com");
                    launchUrl(link!, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.email, color: Colors.black)),
              IconButton(
                  onPressed: () {
                    link = Uri.parse("https://www.facebook.com/gazi.hamada/");
                    launchUrl(link!, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                    size: 20,
                  )),
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
                    Clef.Treble,
                  ]),
                  onNotePositionTapped: (position) {
                    // Use an audio library like flutter_midi to play the sound
                    flutterMidi.playMidiNote(midi: position.pitch);
                  },
                ),
              ))),
    );
  }
}
