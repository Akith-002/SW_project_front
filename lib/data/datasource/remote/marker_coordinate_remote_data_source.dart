import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';

abstract class MarkerCoordinateRemoteDataSource {
  Future<MarkerCoordinateResponse> saveBuildingRatesCoordinate(
      MarkerCoordinateModel marker);
  Future<MarkerCoordinateResponse> savePastValuationsCoordinate(
      MarkerCoordinateModel marker);
  Future<MarkerCoordinateResponse> saveRentalEvidenceCoordinate(
      MarkerCoordinateModel marker);
  Future<MarkerCoordinateResponse> saveSalesEvidenceCoordinate(
      MarkerCoordinateModel marker);

  // GET methods for existing markers
  Future<List<ExistingMarkerModel>> getBuildingRatesCoordinates(
      int masterfileId);
  Future<List<ExistingMarkerModel>> getPastValuationsCoordinates(
      int masterfileId);
  Future<List<ExistingMarkerModel>> getRentalEvidenceCoordinates(
      int masterfileId);
  Future<List<ExistingMarkerModel>> getSalesEvidenceCoordinates(
      int masterfileId);
}

class MarkerCoordinateRemoteDataSourceImpl
    implements MarkerCoordinateRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  MarkerCoordinateRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MarkerCoordinateResponse> saveBuildingRatesCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(
        marker, '/BuildingRatesLACoordinate', 'Building Rates');
  }

  @override
  Future<MarkerCoordinateResponse> savePastValuationsCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(
        marker, '/PastValuationsLACoordinate', 'Past Valuations');
  }

  @override
  Future<MarkerCoordinateResponse> saveRentalEvidenceCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(
        marker, '/RentalEvidenceLACoordinate', 'Rental Evidence');
  }

  @override
  Future<MarkerCoordinateResponse> saveSalesEvidenceCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(
        marker, '/SalesEvidenceLACoordinate', 'Sales Evidence');
  }

  @override
  Future<List<ExistingMarkerModel>> getBuildingRatesCoordinates(
      int masterfileId) async {
    return _getMarkerCoordinates(masterfileId,
        '/BuildingRatesLACoordinate/masterfile', 'Building Rates');
  }

  @override
  Future<List<ExistingMarkerModel>> getPastValuationsCoordinates(
      int masterfileId) async {
    return _getMarkerCoordinates(masterfileId,
        '/PastValuationsLACoordinate/masterfile', 'Past Valuations');
  }

  @override
  Future<List<ExistingMarkerModel>> getRentalEvidenceCoordinates(
      int masterfileId) async {
    return _getMarkerCoordinates(masterfileId,
        '/RentalEvidenceLACoordinate/masterfile', 'Rental Evidence');
  }

  @override
  Future<List<ExistingMarkerModel>> getSalesEvidenceCoordinates(
      int masterfileId) async {
    return _getMarkerCoordinates(masterfileId,
        '/SalesEvidenceLACoordinate/masterfile', 'Sales Evidence');
  }

  Future<MarkerCoordinateResponse> _saveMarkerCoordinate(
    MarkerCoordinateModel marker,
    String endpoint,
    String markerType,
  ) async {
    try {
      // Debug: Log API call details
      _logger.d(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: MAKING API CALL =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Marker Type: $markerType');
      _logger.d('Marker data: ${marker.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: marker.toJson(),
      );

      // Debug: Log API response details
      _logger.d(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkerCoordinateResponse(
          success: true,
          message: response.data['message'] ??
              '$markerType coordinate saved successfully',
          data: response.data,
        );
      } else {
        _logger.e(
            '======= MARKER COORDINATE REMOTE DATA SOURCE: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: DIO EXCEPTION =======');
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');
      _logger.e('Request URL: ${e.requestOptions.uri}');
      _logger.e('Request Method: ${e.requestOptions.method}');
      _logger.e('Request Headers: ${e.requestOptions.headers}');
      _logger.e('Response: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }

  Future<List<ExistingMarkerModel>> _getMarkerCoordinates(
    int masterfileId,
    String endpointBase,
    String markerType,
  ) async {
    try {
      final endpoint = '$endpointBase/$masterfileId';

      // Debug: Log API call details
      _logger.d(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: FETCHING EXISTING MARKERS =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Marker Type: $markerType');
      _logger.d('Master File ID: $masterfileId');
      _logger.d('===========================================');

      final response = await dioClient.get(endpoint);

      // Debug: Log API response details
      _logger.d(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: GET API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => ExistingMarkerModel.fromJson(json)).toList();
      } else {
        _logger.e(
            '======= MARKER COORDINATE REMOTE DATA SOURCE: GET API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: GET DIO EXCEPTION =======');
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');
      _logger.e('Request URL: ${e.requestOptions.uri}');
      _logger.e('Response: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e(
          '======= MARKER COORDINATE REMOTE DATA SOURCE: GET UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
