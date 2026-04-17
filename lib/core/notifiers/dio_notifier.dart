import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioNotifier = Provider<Dio>((ref) {
  try {
    final dio = Dio();
    dio.options.baseUrl = const String.fromEnvironment('API_URL');
    return dio;
  } catch (e) {
    throw Exception('Error initializing Dio: $e');
  }
});