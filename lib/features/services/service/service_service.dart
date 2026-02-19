import 'package:easy_laba/features/services/model/branch_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceService extends ChangeNotifier {
  final SupabaseClient _client;

  ServiceService(this._client);

  List<ServiceModel> services = [];

  Future<void> getServices() async {
    try {
      final result = await _client.from('view_services').select();

      services = result
          .map(
            (Map<String, dynamic> res) => ServiceModel(
              id: res['id'],
              name: res['name'],
              price: res['price'],
            ),
          )
          .toList();
      notifyListeners();
    } catch (error) {
      print("Supabase error: $error");

      services = [];
    }
  }
}
