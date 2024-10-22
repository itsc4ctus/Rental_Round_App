import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsAndConditions extends StatefulWidget {
  TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  String? markDown;

  @override
  void initState() {
    _loadMarkDown();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadMarkDown() async {
    final String data = await rootBundle
        .loadString('lib/assets/mdfiles/terms_and_conditions.md');
    setState(() {
      markDown = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy policy"),
      ),
      body: SafeArea(
          child: markDown == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Markdown(data: markDown!),
                )),
    );
  }
}
