import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/land_acquisition.dart';

class LAMasterfileService {
  final String baseUrl = "http://10.0.2.2:5221/api/Auth/LAMasterFile";

  Future<List<LandAquisitionMasterFile>> fetchAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['masterFiles'];
      return List<LandAquisitionMasterFile>.from(
        data.map((item) => LandAquisitionMasterFile.fromJson(item)),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<LandAquisitionMasterFile>> search(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['masterFiles'];
      return List<LandAquisitionMasterFile>.from(
        data.map((item) => LandAquisitionMasterFile.fromJson(item)),
      );
    } else {
      throw Exception('Search failed');
    }
  }
}
