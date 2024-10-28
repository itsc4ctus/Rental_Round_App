import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String? markDown;

  @override
  void initState() {
    _loadMarkDown();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadMarkDown() async {
    final String data =
        await rootBundle.loadString('lib/assets/mdfiles/privacy_policy.md');
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
