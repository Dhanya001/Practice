import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter/services.dart';

class SubtitleEditor extends StatefulWidget {
  const SubtitleEditor({Key? key}) : super(key: key);

  @override
  State<SubtitleEditor> createState() => _SubtitleEditorState();
}

class _SubtitleEditorState extends State<SubtitleEditor> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  void _saveContent() {
    final docJson = _controller.document.toDelta().toJson();
    print("Saved JSON: $docJson");
    // You can save this to a local DB, file, or server
  }

  void _loadContent() {
    final sampleJson = [
      {"insert": "Hello there\n"}
    ];
    final doc = Document.fromJson(sampleJson);
    _controller.document = doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subtitle Text Editor"),
        actions: [
          ElevatedButton.icon(
            onPressed: _saveContent,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _loadContent,
            icon: const Icon(Icons.download),
            label: const Text('Load'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          QuillToolbar.basic(
            controller: _controller,
            showUndo: true,
            showRedo: true,
            showFontFamily: true,
            showFontSize: true,
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showStrikeThrough: true,
            showInlineCode: true,
            showColorButton: true,
            showBackgroundColorButton: true,
            showCodeBlock: true,
            showListBullets: true,
            showListNumbers: true,
            showCheckbox: true,
            showQuote: true,
            showIndent: true,
            showAlignmentButtons: true,
            showLink: true,
            showClearFormat: true,
          ),
          const Divider(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: _focusNode,
                autoFocus: false,
                readOnly: false,
                expands: true,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
MaterialApp(
  debugShowCheckedModeBanner: false,
  supportedLocales: const [
    Locale('en'),
    Locale('es'),
  ],
  localizationsDelegates: const [
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    ...FlutterQuillLocalizations.delegates,
  ],
  home: SubtitleEditor(),
);
