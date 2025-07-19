import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:land_asset_valuation/data/models/mr_request_model.dart';

class DownloadService {
  static Future<void> downloadRequestAsJson(MrRequest request) async {
    try {
      final data = {
        'requestInformation': {
          'id': request.id,
          'ratingReferenceNo': request.ratingReferenceNo,
          'localAuthority': request.localAuthority,
          'yearOfRevision': request.yearOfRevision,
          'status': request.status ? 'Active' : 'Inactive',
          'requestType': {
            'code': request.requestType.code,
            'name': request.requestType.name,
          },
          'createdAt': request.createdAt.toIso8601String(),
          'updatedAt': request.updatedAt.toIso8601String(),
        },
        'downloadedAt': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      await _saveAndShareFile(
        jsonString,
        'request_${request.ratingReferenceNo}.json',
      );
    } catch (e) {
      print('Error downloading request: $e');
      rethrow;
    }
  }

  static Future<void> downloadRequestAsCsv(MrRequest request) async {
    try {
      final csvContent = StringBuffer();
      
      // Add headers
      csvContent.writeln('Field,Value');
      
      // Add data
      csvContent.writeln('ID,${request.id}');
      csvContent.writeln('Rating Reference No,${request.ratingReferenceNo}');
      csvContent.writeln('Local Authority,${request.localAuthority}');
      csvContent.writeln('Year of Revision,${request.yearOfRevision}');
      csvContent.writeln('Status,${request.status ? "Active" : "Inactive"}');
      csvContent.writeln('Request Type Code,${request.requestType.code}');
      csvContent.writeln('Request Type Name,${request.requestType.name}');
      csvContent.writeln('Created At,${request.createdAt.toIso8601String()}');
      csvContent.writeln('Updated At,${request.updatedAt.toIso8601String()}');
      csvContent.writeln('Downloaded At,${DateTime.now().toIso8601String()}');

      await _saveAndShareFile(
        csvContent.toString(),
        'request_${request.ratingReferenceNo}.csv',
      );
    } catch (e) {
      print('Error downloading request as CSV: $e');
      rethrow;
    }
  }

  static Future<void> downloadAllRequestsAsJson(List<MrRequest> requests) async {
    try {
      final data = {
        'totalRequests': requests.length,
        'requests': requests.map((request) => {
          'id': request.id,
          'ratingReferenceNo': request.ratingReferenceNo,
          'localAuthority': request.localAuthority,
          'yearOfRevision': request.yearOfRevision,
          'status': request.status ? 'Active' : 'Inactive',
          'requestType': {
            'code': request.requestType.code,
            'name': request.requestType.name,
          },
          'createdAt': request.createdAt.toIso8601String(),
          'updatedAt': request.updatedAt.toIso8601String(),
        }).toList(),
        'downloadedAt': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      await _saveAndShareFile(
        jsonString,
        'all_requests_${DateTime.now().millisecondsSinceEpoch}.json',
      );
    } catch (e) {
      print('Error downloading all requests: $e');
      rethrow;
    }
  }

  static Future<void> downloadAllRequestsAsCsv(List<MrRequest> requests) async {
    try {
      final csvContent = StringBuffer();
      
      // Add headers
      csvContent.writeln('ID,Rating Reference No,Local Authority,Year of Revision,Status,Request Type Code,Request Type Name,Created At,Updated At');
      
      // Add data
      for (final request in requests) {
        csvContent.writeln(
          '${request.id},'
          '${request.ratingReferenceNo},'
          '${request.localAuthority},'
          '${request.yearOfRevision},'
          '${request.status ? "Active" : "Inactive"},'
          '${request.requestType.code},'
          '${request.requestType.name},'
          '${request.createdAt.toIso8601String()},'
          '${request.updatedAt.toIso8601String()}'
        );
      }

      await _saveAndShareFile(
        csvContent.toString(),
        'all_requests_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
    } catch (e) {
      print('Error downloading all requests as CSV: $e');
      rethrow;
    }
  }

  static Future<void> _saveAndShareFile(String content, String filename) async {
    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$filename');
      
      // Write content to file
      await file.writeAsString(content);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Request Information',
        text: 'Download $filename',
      );
      
      // Clean up the temporary file after sharing (optional)
      // You might want to keep it for a while or clean it up later
      Future.delayed(const Duration(seconds: 5), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      print('Error saving and sharing file: $e');
      rethrow;
    }
  }
}