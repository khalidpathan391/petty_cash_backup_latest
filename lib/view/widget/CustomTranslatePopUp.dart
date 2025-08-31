// Make This
// floatingActionButton: AppUtils.translationIcon(context),

import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:translator/translator.dart';

class TranslatePopUp extends StatefulWidget {
  static const String id = "translate_pop_up";
  final String initialText;
  const TranslatePopUp({
    super.key,
    this.initialText = '',
  });

  @override
  State<TranslatePopUp> createState() => _TranslatePopUpState();
}

class _TranslatePopUpState extends State<TranslatePopUp> {
  final translator = GoogleTranslator();

  String translatedText = '';

  @override
  void initState() {
    super.initState();
    translatedText = widget.initialText;
    translateText(widget.initialText);
  }

  void translateText(String text) async {
    translator.translate(text, to: selectedValue).then((value) {
      setState(() {
        translatedText = value.text;
      });
    });
  }

  String selectedLanguage = Global.defaultTransLan!;
  String selectedValue = Global.transLanVal!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: context.resources.color.themeColor,
        title: Container(
          height: AppHeight(30),
          width: AppWidthP(33),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: .2),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: AppHeight(20)),
          child: DropdownButton<String>(
            value: selectedLanguage,
            icon: const RotatedBox(
              quarterTurns: 3,
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 15),
            ),
            isExpanded: true,
            elevation: 16,
            style: TextStyle(color: context.resources.color.themeColor),
            padding: EdgeInsets.symmetric(horizontal: AppWidth(5)),
            underline: Container(height: 0),
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
                selectedValue = Global.languageMap[newValue]!;
                translateText(widget.initialText);
              });
            },
            items: Global.languageMap.entries
                .map((MapEntry<String, String> entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: CommonTextView(
                  label: entry.key,
                  maxLine: 1,
                  overFlow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonTextView(
              label: translatedText.isNotEmpty
                  ? translatedText
                  : 'Translated Text',
              color: translatedText.isNotEmpty ? Colors.black : Colors.grey,
              alignment: Alignment.topLeft,
              fontSize: context.resources.dimension.appBigText,
              isSelectable: true,
              // height: AppHeightP(50),
              padding: const EdgeInsets.all(20),
              // margin: EdgeInsets.symmetric(vertical: AppHeight(20)),
            ),
          ],
        ),
      ),
    );
  }
}
