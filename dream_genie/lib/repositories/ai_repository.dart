import 'dart:convert';

import 'package:dream_genie/models/init_data.dart';
import 'package:dream_genie/models/update_data.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

abstract class IAIRepository {
  Future<Map<String, dynamic>> createSchedule(InitData initdata);

  Future<Map<String, dynamic>> updateSchedule(UpdateData updatedata);

  Future<void> acceptUpdate(Map<String, dynamic> json);
}

class AIRepository implements IAIRepository {
  final http.Client client;

  AIRepository(this.client);

  @override
  Future<Map<String, dynamic>> createSchedule(InitData initdata) async {
    try {
      // TODO: send real data
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
  Future<Map<String, dynamic>> updateSchedule(UpdateData updatedata) async {
    try {
      // TODO: send real data
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

  @override
  Future<void> acceptUpdate(Map<String, dynamic> json) async {
    try {
      // TODO: send real data
      await client.get(
        Uri.parse(ApiEndpoints.ganttGenerate),
      );
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}

class MockAIRepository implements IAIRepository {
  MockAIRepository();

  @override
  Future<Map<String, dynamic>> createSchedule(InitData initdata) async {
    try {
      final response =
          await rootBundle.loadString("assets/dummy_ai_response_data.json");
      final data = jsonDecode(response);
      await Future.delayed(const Duration(seconds: 5));
      return data;
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateSchedule(UpdateData updatedata) async {
    try {
      final response =
          await rootBundle.loadString("assets/dummy_ai_response_data2.json");
      final data = jsonDecode(response);
      await Future.delayed(const Duration(seconds: 5));
      return data;
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  @override
  Future<void> acceptUpdate(Map<String, dynamic> json) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
