import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class QuillTextField extends StatelessWidget {
  final QuillController controller;
  /*Make it like this
   QuillController controller = QuillController.basic();
  do this to get html file
  import 'package:quill_html_converter/quill_html_converter.dart';
    Convert Delta to HTML
    final html = controller.document.toDelta().toHtml();
    // Load Delta document using HTML
    // controller.document = Document.fromDelta(Document.fromHtml(html));
  */
  const QuillTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeightP(40),
      decoration: BoxDecoration(
        border: Border.all(
            color: context.resources.color.themeColor.withOpacity(.5),
            width: .5),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppWidth(10)),
      child: Column(
        children: [
          // IconButton(onPressed: (){
          //   final data = jsonEncode(controller.document.toDelta().toJson());
          //   final myData = jsonDecode(data);
          //   controller.document = Document.fromJson(myData);
          //   print(controller.document.toPlainText().toString(),);
          // }, icon: const Icon(Icons.add)),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: context.resources.color.themeColor.withOpacity(.5),
              width: .2,
            ))),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: controller,
                showItalicButton: true,
                showColorButton: true,
                showBoldButton: true,
                showClearFormat: true,
                showListBullets: true,
                showUnderLineButton: true,
                showBackgroundColorButton: false,
                showAlignmentButtons: false,
                showFontSize: false,
                showFontFamily: false,
                showCodeBlock: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showUndo: false,
                showRedo: false,
                showSearchButton: false,
                showHeaderStyle: false,
                showCenterAlignment: false,
                showDirection: false,
                showDividers: false,
                showIndent: false,
                showInlineCode: false,
                showJustifyAlignment: false,
                showLink: false,
                showListCheck: false,
                showListNumbers: false,
                showQuote: false,
                showSmallButton: false,
                showStrikeThrough: false,
                showSubscript: false,
                showSuperscript: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: controller,
                // isReadOnly: false,
                // keyboardAppearance: TextInputType.multiline,
                enableSelectionToolbar: true,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
                placeholder: 'Add Text Here',
                // autoFocus: true,
                onTapOutside: (event, focusNode) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
