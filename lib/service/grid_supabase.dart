import 'package:flutter_application_huerto/models/community.dart';
import 'package:flutter_application_huerto/models/userLoged.dart';
import 'package:flutter_application_huerto/service/supabaseService.dart';
import 'package:flutter_application_huerto/service/user_supabase.dart';
import 'package:flutter_guid/flutter_guid.dart';

import '../models/grid.dart';

class GridSupabase {
  final service = SupabaseService().client;

  Future<GridDto?> getGridDataByCommunityId(Guid idCommunity) async {
    try {
      final data =
      await service.from("Grid").select("*").eq("community_id", idCommunity.value);
      if (data.isEmpty) {
        return null;
      } else {
        return GridDto.fromJson(data);
      }
    } catch (e) {
      print('Error en clase grid_supabase al leer datos: $e');
      return null;
    }
  }

}
