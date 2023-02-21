import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/item_model.dart';
import '../error/failure_model.dart';

abstract class BudgetRepository {
  Future<List<Item>> getItems();
  void dispose();
}

class BudgetRepositoryImpl implements BudgetRepository {
  static const String _baseUrl = 'https://api.notion.com/v1/';
  final http.Client client = http.Client();

  @override
  Future<List<Item>> getItems() async {
    try {
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Failure(message: 'Status Code Not 200 !!');
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong !');
    }
  }

  @override
  void dispose() {
    client.close();
  }
}
