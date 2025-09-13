import 'dart:convert';

import 'package:dream_genie/models/init_data.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

abstract class IAIRepository {
  Future<Map<String, dynamic>> create(InitData initdata);

  Future<Map<String, dynamic>> update();
}

class AIRepository implements IAIRepository {
  final http.Client client;

  AIRepository(this.client);

  @override
  Future<Map<String, dynamic>> create(InitData initdata) async {
    try {
      // TODO: send initdata.toJson
      final response = await client.post(
        Uri.parse(ApiEndpoints.ganttGenerate),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update() async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.ganttGenerate),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}

class MockAIRepository implements IAIRepository {
  MockAIRepository();

  @override
  Future<Map<String, dynamic>> create(InitData initdata) async {
    try {
      final response =
          await rootBundle.loadString("dummy_ai_response_data.json");
      final data = jsonDecode(response);
      await Future.delayed(const Duration(seconds: 5));
      return data;
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update() async {
    try {
      final response =
          await rootBundle.loadString("dummy_ai_response_data.json");
      final data = jsonDecode(response);
      await Future.delayed(const Duration(seconds: 5));
      return data;
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
