import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:protool/models/mantra_response.dart';
import 'dart:convert';
import '../services/mantra_service.dart';
import '../widgets/common_widgets.dart';

class MantraScreen extends StatefulWidget {
  const MantraScreen({super.key});

  @override
  State<MantraScreen> createState() => _MantraScreenState();
}

class _MantraScreenState extends State<MantraScreen> {
  final MantraService mantraService = MantraService();
  String _id = '';
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
      final mantraResponse = await mantraService.getMantra();
      if (mounted) {
        setState(() {
          _quote = mantraResponse.content;
          _author = mantraResponse.author;
          _id = mantraResponse.id;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _quote = 'Failed to load mantra.';
          _author = 'System';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
