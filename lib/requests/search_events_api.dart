import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/event.dart';
import 'routes_api.dart';

Future<List<Event>> searchEvents(BuildContext context, String? keyword) async {
  final url = Uri.parse('${RoutesAPI.searchEvents}?q=$keyword');
  final headers = {'Content-Type': 'application/json'};
  print(url);
  try {
    final response = await http.get(
      url,
      headers: headers,
    );
    final jsonResponse = json.decode(response.body);
    //print('Response: ${jsonResponse}');
    int responseStatus = response.statusCode;
    List<Event> eventsList = [];
    if (responseStatus == 200) {
      for (var eventDict in jsonResponse) {
        eventsList.add(Event.fromJson(eventDict));
      }
      return eventsList;
    }
    return [];
  } catch (error) {
    print('Error (Search Events API): $error');
    return [];
  }
}
