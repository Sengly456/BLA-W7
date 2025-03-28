import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/provider/async_value.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;

  RidePreference? get currentPreference => _currentPreference;

  late AsyncValue<List<RidePreference>> pastPreferences= AsyncValue.loading();

  List<RidePreference> get preferencesHistory => pastPreferences.data!.reversed.toList();

  final RidePreferencesRepository repository;

  //constructor
  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  Future<void> fetchPastPreferences() async {
    try {
      final preferences = await repository.getPastPreferences();
      pastPreferences = AsyncValue.success(preferences);
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  void setCurrentPreference(RidePreference preference) {
    _currentPreference = preference;
    notifyListeners();
  }

  Future<void> addPreference(RidePreference preference) async {
    try {
      await repository.addPreference(preference);
      await fetchPastPreferences(); // Refresh history after adding
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }
}
