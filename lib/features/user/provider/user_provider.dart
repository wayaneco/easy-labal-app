import 'package:easy_laba/features/user/model/user_model.dart';
import 'package:easy_laba/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  SupabaseClient client;

  UserProvider(this.client) {
    _loadSavedData();
  }

  UserModel? user;
  String? branchId;
  String? coWorkerId;
  bool isDoneSelect = false;

  Future<void> _loadSavedData() async {
    final String? userJson = await StorageService.getString('userData');
    final String? isDoneSelectString = await StorageService.getString(
      'isDoneSelect',
    );

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      user = UserModel.fromJson(userMap);
    }

    branchId = await StorageService.getString('branchId');
    coWorkerId = await StorageService.getString('coWorkerId');
    isDoneSelect = jsonDecode(isDoneSelectString as String);

    final startShift = await client.rpc(
      'get_active_staff_shift',
      params: {'p_staff_id': user?.userId},
    );

    print('staftShift ${startShift}');

    notifyListeners();
  }

  Future<void> setUserData(Map<String, dynamic>? userData) async {
    try {
      user = userData == null ? null : UserModel.fromJson(userData);

      await StorageService.setString('userData', jsonEncode(userData));
      notifyListeners();
    } catch (error) {
      print('Failed to get user ${error}');
    }
  }

  void setBranchId(String pBranchId) {
    branchId = pBranchId;

    StorageService.setString('branchId', pBranchId);

    notifyListeners();
  }

  void setCoWorkerId(String? pCoWorkerId) {
    coWorkerId = pCoWorkerId;
    isDoneSelect = true;

    StorageService.setString('isDoneSelect', 'true');

    if (pCoWorkerId != null) {
      StorageService.setString('coWorkerId', pCoWorkerId);
    }

    notifyListeners();
  }

  Future<void> reset() async {
    await client.rpc("end_staff_shift", params: {'p_staff_id': user?.userId});

    user = null;
    branchId = null;
    coWorkerId = null;
    isDoneSelect = false;

    StorageService.clear();

    notifyListeners();
  }
}
