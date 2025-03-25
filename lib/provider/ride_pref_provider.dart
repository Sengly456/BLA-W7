import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;

  RidePreference? get currentPreference => _currentPreference;

  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _pastPreferences = repository.getPastPreferences();
  }


  void setCurrentPreference(RidePreference preference) {
    _currentPreference = preference;
    notifyListeners();
  }

   void addPreference(RidePreference preference) {
    repository.addPreference(preference);
    notifyListeners();
  }

 


  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
  
}
