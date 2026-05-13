import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/common_widgets.dart';

class MantraScreen extends StatefulWidget {
  const MantraScreen({super.key});

  @override
  State<MantraScreen> createState() => _MantraScreenState();
}

class _MantraScreenState extends State<MantraScreen> {
  String _quote = '';
  String _author = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _quote = data['content'];
          _author = data['author'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _quote = 'Failed to fetch mantra. Stay strong!';
          _author = 'System';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _quote = 'Network error. Please try again.';
        _author = 'System';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Mantra"),
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white30,
            width: 0.5,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"$_quote"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '- $_author',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 48),
                    PrimaryButton(
                      onPressed: _fetchQuote,
                      text: 'New Mantra',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
