import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

abstract class KycRemoteDataSource {
  Future<String> getUploadUrl(String fileName, String fileType);
  Future<void> uploadFileToUrl(String url, File file, String contentType);
  Future<void> submitKycRequest(String frontDocUrl, String selfieUrl);
}

class KycRemoteDataSourceImpl implements KycRemoteDataSource {
  final ApiClient apiClient;

  KycRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> getUploadUrl(String fileName, String fileType) async {
    try {
      final response = await apiClient.dio.post(
        '/kyc/upload-url',
        data: {
          'filename': fileName,
          'file_type': fileType,
        },
      );
      return response.data['upload_url'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to get upload URL');
    }
  }

  @override
  Future<void> uploadFileToUrl(String url, File file, String contentType) async {
    try {
      // Direct upload to S3/Supabase using standard Dio (no auth header needed for presigned url usually, 
      // but here we use a separate Dio instance to avoid adding our API auth header if it conflicts, 
      // though usually presigned URLs ignore extra headers or we need to be careful)
      // Actually, for presigned PUT, we need to be careful with headers.
      
      final dio = Dio(); // New instance for external upload
      
      await dio.put(
        url,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': await file.length(),
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Failed to upload file: ${e.message}');
    }
  }

  @override
  Future<void> submitKycRequest(String frontDocUrl, String selfieUrl) async {
    try {
      await apiClient.dio.post(
        '/kyc/submit',
        data: {
          'front_doc_url': frontDocUrl,
          'selfie_url': selfieUrl,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to submit KYC');
    }
  }
}
