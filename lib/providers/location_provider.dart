// lib/providers/location_provider.dart
import 'package:flutter/material.dart';
import '../models/trending_video.dart';
import '../services/mock_data_service.dart';

class LocationProvider with ChangeNotifier {
  String? _currentCountry = 'India';
  String? _currentState;
  String? _currentDistrict;
  String? _currentCity;
  bool _isDetecting = false;
  bool _locationPermissionGranted = false;
  String? _error;

  // Available options
  final List<String> states = MockDataService.getIndianStates();
  final Map<String, List<String>> districtsByState = MockDataService.getDistrictsByState();

  String? get currentCountry => _currentCountry;
  String? get currentState => _currentState;
  String? get currentDistrict => _currentDistrict;
  String? get currentCity => _currentCity;
  bool get isDetecting => _isDetecting;
  bool get locationPermissionGranted => _locationPermissionGranted;
  String? get error => _error;

  LocationFilter get currentFilter => LocationFilter(
    country: _currentCountry,
    state: _currentState,
    district: _currentDistrict,
    city: _currentCity,
  );

  String get displayLocation {
    if (_currentCity != null) return _currentCity!;
    if (_currentDistrict != null) return _currentDistrict!;
    if (_currentState != null) return _currentState!;
    if (_currentCountry != null) return _currentCountry!;
    return 'Global';
  }

  Future<void> detectLocation() async {
    _isDetecting = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate GPS detection
      await Future.delayed(const Duration(seconds: 2));
      // Mock: detected Hyderabad
      _currentCountry = 'India';
      _currentState = 'Telangana';
      _currentDistrict = 'Hyderabad';
      _currentCity = 'Hyderabad';
      _locationPermissionGranted = true;
    } catch (e) {
      _error = 'Could not detect location. Please select manually.';
    } finally {
      _isDetecting = false;
      notifyListeners();
    }
  }

  void setLocation({String? country, String? state, String? district, String? city}) {
    _currentCountry = country ?? _currentCountry;
    _currentState = state;
    _currentDistrict = district;
    _currentCity = city;
    notifyListeners();
  }

  void setState_(String? state) {
    _currentState = state;
    _currentDistrict = null;
    _currentCity = null;
    notifyListeners();
  }

  void setDistrict(String? district) {
    _currentDistrict = district;
    _currentCity = null;
    notifyListeners();
  }

  void clearLocation() {
    _currentState = null;
    _currentDistrict = null;
    _currentCity = null;
    notifyListeners();
  }

  List<String> getDistricts() {
    if (_currentState == null) return [];
    return districtsByState[_currentState] ?? [];
  }
}
