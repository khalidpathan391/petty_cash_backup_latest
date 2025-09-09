import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class QuillTextField extends StatefulWidget {
  final QuillController controller;
  final void Function(String)? onChange;
  final double? height;

  const QuillTextField({
    super.key,
    required this.controller,
    this.onChange,
    this.height,
  });

  @override
  State<QuillTextField> createState() => _QuillTextFieldState();
}

class _QuillTextFieldState extends State<QuillTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onContentChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onContentChange);
    super.dispose();
  }

  void _onContentChange() {
    if (widget.onChange != null) {
      final plainText = widget.controller.document.toPlainText();
      widget.onChange!(plainText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = widget.height ?? screenHeight * 0.3;

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
            child: Builder(
              builder: (context) {
                try {
                  return QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                      controller: widget.controller,
                      enableSelectionToolbar: true,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('en'),
                      ),
                      placeholder: 'Add Text Here',
                      onTapOutside: (event, focusNode) {
                        // Clear selection when tapping outside
                        try {
                          widget.controller.updateSelection(
                            const TextSelection.collapsed(offset: 0),
                            ChangeSource.local,
                          );
                        } catch (e) {
                          // Ignore selection errors
                        }
                      },
                    ),
                  );
                } catch (e) {
                  // Fallback UI if QuillEditor fails
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(
                        text: widget.controller.document.toPlainText(),
                      ),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Add Text Here',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Update the Quill controller when text changes
                        try {
                          final len = widget.controller.document.length;
                          if (len > 0) {
                            widget.controller.document.delete(0, len);
                          }
                          if (value.isNotEmpty) {
                            widget.controller.document.insert(0, value);
                          }
                        } catch (e) {
                          // Ignore update errors
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
