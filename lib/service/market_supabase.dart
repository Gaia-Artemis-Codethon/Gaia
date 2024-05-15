import 'package:flutter/material.dart';
import 'package:flutter_application_huerto/main.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/market.dart';
import 'supabaseService.dart';

class MarketSupabase {
  final client = SupabaseService().client;

  Future<void> addMarketPost(Market marketPost) async {
    try {
      Map<String, dynamic> marketPostMap = Market.toJson(marketPost);
      // Llamar a Supabase().addData con el Map del post
      await SupabaseService().addData("Marketplace", marketPostMap);
    } catch (e) {
      print('Error al insertar datos: $e');
    }
  }

  Future<Market?> getMarketPostById(Guid id) async {
    final data = await SupabaseService().readDataById("Marketplace", id.value);
    if (data.length == 0) {
      return null;
    } else {
      final marketPost = Market.fromJson(data);
      return marketPost;
    }
  }

  Future<void> deleteMarketPostById(Guid id) async {
    await SupabaseService().deleteData("Marketplace", id.value);
  }

  Stream<List<Market>> getMarketByCommunityId(Guid community_id) {
    return client
        .from('Marketplace')
        .select()
        .eq('community', community_id.value)
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map((list) =>
        list.map((item) => Market.fromJson(item) as Market).toList());
  }

  Stream<List<Market>> getMarketByUserId(Guid user_id) {
    return client
        .from('Marketplace')
        .select()
        .eq('user', user_id.value)
        .asStream()
        .map((event) => event as List<Map<String, dynamic>>)
        .map((list) =>
        list.map((item) => Market.fromJson(item) as Market).toList());
  }

  Future<void> updateMarketPostById(Guid id, Market marketPost) async {
    Map<String, dynamic> newValues = Market.toJson(marketPost);
    await SupabaseService().updateData("Marketplace", id.value, newValues);
  }
}
