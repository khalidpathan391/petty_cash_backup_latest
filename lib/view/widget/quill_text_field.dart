import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class QuillTextField extends StatefulWidget {
  final QuillController controller;
  final void Function(String)? onChange;

  const QuillTextField({
    super.key,
    required this.controller,
    this.onChange,
  });

  @override
  State<QuillTextField> createState() => _QuillTextFieldState();
}

class _QuillTextFieldState extends State<QuillTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Add a listener to detect changes
    widget.controller.addListener(_onContentChange);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_onContentChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onContentChange() {
    if (widget.onChange != null) {
      final plainText = widget.controller.document.toPlainText();
      widget.onChange!(plainText); // Trigger the callback with the updated text
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.4; // 40% of the screen height

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.resources.color.themeColor,
          width: .5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.resources.color.themeColor,
                  width: .2,
                ),
              ),
            ),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: widget.controller,
                showItalicButton: false,
                showColorButton: false,
                showBoldButton: false,
                showClearFormat: false,
                showListBullets: false,
                showUnderLineButton: false,
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
            child: Focus(
              focusNode: _focusNode,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: widget.controller,
                  enableSelectionToolbar: true,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                  placeholder: 'Add Text Here',
                  onTapOutside: (event, focusNode) {
                    // Prevent keyboard from closing when tapping outside
                    focusNode.unfocus();
                  },
                  autoFocus: false,
                  scrollable: true,
                  expands: true,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
