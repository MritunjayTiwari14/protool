
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:protool/models/mantra_response.dart';

class MantraService {
  Future<MantraResponse> getMantra() async {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final http.Client client = IOClient(ioClient);
    try {
      final response = await client.get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MantraResponse(
          id: data['_id'] ?? '',
          content: data['content'],
          author: data['author'],
        );
      } else {
        return MantraResponse(
          id: '-1',
          content: 'Failed to fetch mantra. Stay strong!',
          author: 'System',
        );
      }
    } catch (e) {
      return MantraResponse(
        id: '-2',
        content: e.toString(),
        author: 'System',
      );
    } finally {
      client.close();
    }
  }
}