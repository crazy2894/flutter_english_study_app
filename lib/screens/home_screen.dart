import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //초기값
  List<String> contents = [];
  List<String> wonraecontents = [];
  List<String> removedcontents = [];
  String displaytextupper = '문제가 들어있는 박스입니다.';
  String displaytextlower = 'This box contains the answer.';
  String engText = 'This box contains the answer.';
  String korText = '한글 문장 (문제)';
  String headline = "하단의 문서 표시 아이콘을 눌러주세요";
  bool mod = true;
  Color color1 = const Color.fromARGB(255, 233, 235, 226);
  Color color2 = const Color.fromARGB(109, 145, 206, 139);
  Color myfontcolor = Colors.black45;
  Icon modicon = const Icon(Icons.dark_mode_rounded, color: Colors.black45);
  bool waitingtime = false;
  int countnumber = 0;
  int keFs = 15;

  //파일 선택 누를시에
  Future<void> pickFile() async {
    contents = [];
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

    if (result != null) {
      String filePath = result.files.first.path!;
      // Use the file.
      File file = File(filePath);
      contents = await file.readAsLines();
      wonraecontents = contents;
      previousPressed();
      setState(() {
        headline = '남은문제 ${countnumber + 1} / ${contents.length}';
      });
    }
  }

  //다음문제누를시에
  void nextPressed() {
    if (contents.isNotEmpty) {
      if (countnumber <= 0) {
        countnumber = 0;
        countnumber = countnumber + 1;
      } else {
        if (countnumber < contents.length - 1) {
          countnumber = countnumber + 1;
        }
      }
      var item = contents[countnumber];
      List<String> itemList = (item.split('\t'));
      engText = itemList.first;
      korText = itemList.last;
      setState(() {
        displaytextupper = korText;
        displaytextlower = '';
        headline = '남은문제 ${countnumber + 1} / ${contents.length}';
      });
    }
  }

  void previousPressed() {
    if (contents.isNotEmpty) {
      if (countnumber <= 0) {
        countnumber = 0;
      } else {
        countnumber = countnumber - 1;
      }

      var item = contents[countnumber];
      List<String> itemList = (item.split('\t'));
      engText = itemList.first;
      korText = itemList.last;
      setState(() {
        displaytextupper = korText;
        displaytextlower = '';
        headline = '남은문제 ${countnumber + 1} / ${contents.length}';
      });
    }
  }

  void mixtheproblem() {
    setState(() {
      contents.shuffle();
      int i = 0;
      while (i < contents.length) {
        previousPressed();
        i = i + 1;
      }
    });
  }

  //위의 텍스트 상자를 누를시에
  void textPressedupper() {}

  //및의 텍스트 상자를 누를시에
  void textPressedlow() async {
    if (displaytextlower == engText) {
      setState(() {
        displaytextlower = '';
      });
    } else {
      setState(() {
        displaytextlower = engText;
      });
    }
  }

  //영어음성 재생 클릭시
  void voiceclicked() async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.stop();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.speak(engText);
  }

  //어둡게 밝게 모드
  void changemod() {
    if (mod == false) {
      setState(() {
        mod = true;
        color1 = const Color.fromARGB(255, 233, 235, 226);
        color2 = const Color.fromARGB(109, 145, 206, 139);
        myfontcolor = Colors.black45;
        modicon = Icon(Icons.dark_mode_rounded, color: myfontcolor);
      });
    } else {
      setState(() {
        mod = false;
        color1 = const Color.fromARGB(255, 25, 25, 26);
        color2 = const Color.fromARGB(108, 20, 20, 20);
        myfontcolor = Colors.white54;
        modicon = Icon(Icons.sunny, color: myfontcolor);
      });
    }
  }

  //폰트사이즈 올리기 내리기
  void fsup() {
    setState(() {
      keFs = keFs + 5;
    });
  }

  void fsdown() {
    setState(() {
      keFs = keFs - 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        toolbarHeight: 25,
        centerTitle: true,
        backgroundColor: color2,
        elevation: 0.2,
        title: AutoSizeText(
          headline,
          style: TextStyle(
            fontSize: 15,
            color: myfontcolor,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textButtons(displaytextupper, textPressedupper),
            textButtons(displaytextlower, textPressedlow),
            Flexible(
              fit: FlexFit.tight,
              flex: 10,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(64, 59, 112, 83)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: IconButton(
                          onPressed: voiceclicked,
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      ),
                    ),
                    everybutton('이전문제', previousPressed),
                    everybutton('다음문제', nextPressed),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: IconButton(
                          onPressed: voiceclicked,
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 20,
                  onPressed: pickFile,
                  icon: Icon(
                    Icons.article_sharp,
                    color: myfontcolor,
                  ),
                ),
                textButtons2("폰트-", fsdown),
                textButtons2("문제섞기", mixtheproblem),
                textButtons2("폰트+", fsup),
                IconButton(iconSize: 20, onPressed: changemod, icon: modicon),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Flexible textButtons(textbuttonspressedon, whenPressed) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 10,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(64, 59, 112, 83)),
        child: TextButton(
          onPressed: whenPressed,
          child: AutoSizeText(
            textbuttonspressedon,
            style: TextStyle(
                fontSize: keFs + 0,
                color: myfontcolor,
                fontWeight: FontWeight.w600),
            maxLines: 111,
          ),
        ),
      ),
    );
  }

  TextButton textButtons2(textbuttonspressedon, whenPressed) {
    return TextButton(
      onPressed: whenPressed,
      child: AutoSizeText(
        textbuttonspressedon,
        style: TextStyle(
            fontSize: 15, color: myfontcolor, fontWeight: FontWeight.w600),
        maxLines: 111,
      ),
    );
  }

  Flexible everybutton(String text, ifpress) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 10,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: TextButton(
          onPressed: ifpress,
          child: AutoSizeText(
            text,
            style: TextStyle(
              fontSize: 22,
              color: myfontcolor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
