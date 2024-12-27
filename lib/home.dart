import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
var languages = [
  'Hindi', 'English', 'Punjabi', 'Spanish', 'French', 'German', 'Italian',
  'Bengali', 'Telugu', 'Marathi', 'Tamil', 'Gujarati', 'Urdu', 'Kannada',
  'Malayalam', 'Odia', 'Assamese', 'Maithili', 'Swahili', 'Russian', 
  'Arabic', 'Chinese', 'Japanese', 'Korean', 'Portuguese', 'Turkish', 'Dutch'
];
  var originLanguage = 'From';
  var destinationLanguage = "To";
  var output = "";

  TextEditingController languageController = TextEditingController();

  void translate(String src, String dest, String input) async {
    GoogleTranslator translator = GoogleTranslator();
    var translation = await translator.translate(input, from: src, to: dest);
    setState(() {
      output = translation.text.toString();
    });

    if (src == '--' || dest == '--') {
      setState(() {
        output = 'Failed';
      });
    }
  }

String getLanguageCode(String language) {
  switch (language) {
    case "English":
      return "en";
    case "Hindi":
      return "hi";
    case "Punjabi":
      return "pa";
    case "Spanish":
      return "es";
    case "French":
      return "fr";
    case "German":
      return "de";
    case "Italian":
      return "it";
    case "Bengali":
      return "bn";
    case "Telugu":
      return "te";
    case "Marathi":
      return "mr";
    case "Tamil":
      return "ta";
    case "Gujarati":
      return "gu";
    case "Urdu":
      return "ur";
    case "Kannada":
      return "kn";
    case "Malayalam":
      return "ml";
    case "Odia":
      return "or";
    case "Assamese":
      return "as";
    case "Maithili":
      return "mai";
    case "Swahili":
      return "sw";
    case "Russian":
      return "ru";
    case "Arabic":
      return "ar";
    case "Chinese":
      return "zh";
    case "Japanese":
      return "ja";  // Added the language code for Japanese
    case "Korean":
      return "ko";
    case "Portuguese":
      return "pt";
    case "Turkish":
      return "tr";
    case "Dutch":
      return "nl";
    default:
      return '--';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Language Translator'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    focusColor: Colors.blue,
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      originLanguage,
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.blueAccent,
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    items: languages.map<DropdownMenuItem<String>>((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        originLanguage = value!;
                      });
                    },
                  ),
                  SizedBox(width: 40),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    focusColor: Colors.blue,
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      destinationLanguage,
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.blueAccent,
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    items: languages.map<DropdownMenuItem<String>>((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        destinationLanguage = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Please Enter your text',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                  controller: languageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter text to translate';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.blue,
                  ),
                  onPressed: () {
                    translate(
                      getLanguageCode(originLanguage),
                      getLanguageCode(destinationLanguage),
                      languageController.text.toString(),
                    );
                  },
                  child: Text('Translate'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "\n$output",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
