import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnable = false;
  String wordSpoken = '';
  double confidencePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnable = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      confidencePercentage = 0.0;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(result) {
    setState(() {
      wordSpoken = "${result.recognizedWords}";
      confidencePercentage = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speech To Text',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        onPressed: (){
          speechToText.isListening ? stopListening() : startListening();
        },
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Text(
                  speechToText.isListening
                      ? 'listening...'
                      : speechEnable
                          ? 'Tap the microphone to start listening...'
                          : 'Error fetching speech',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                wordSpoken,
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 25),
              ),
            ),

            if(speechToText.isNotListening && confidencePercentage >0)
              Text('Confidence: ${(confidencePercentage*100).toStringAsFixed(1)}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
