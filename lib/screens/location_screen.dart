// lib/screens/location_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/trending_provider.dart';
import '../models/trending_video.dart';
import '../constants/app_constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _selectedState;
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    final loc = context.read<LocationProvider>();
    _selectedState = loc.currentState;
    _selectedDistrict = loc.currentDistrict;
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Set Location', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current location card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Current Location', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locationProvider.displayLocation,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  if (locationProvider.currentState != null)
                    Text(
                      '${locationProvider.currentState}, ${locationProvider.currentCountry}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detect location button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: locationProvider.isDetecting
                    ? null
                    : () async {
                        await locationProvider.detectLocation();
                        _applyLocation(context, locationProvider);
                      },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: locationProvider.isDetecting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                    : const Icon(Icons.my_location, color: AppColors.primary),
                label: Text(
                  locationProvider.isDetecting ? 'Detecting...' : 'Use My Location (GPS)',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const _Divider(label: 'OR SELECT MANUALLY'),
            const SizedBox(height: 20),

            // Country (India only for now)
            _DropdownSection(
              label: '🌍 Country',
              value: 'India',
              items: const ['India'],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),

            // State
            _DropdownSection(
              label: '🗺️ State',
              value: _selectedState,
              items: locationProvider.states,
              onChanged: (val) {
                setState(() {
                  _selectedState = val;
                  _selectedDistrict = null;
                });
                locationProvider.setState_(val);
              },
              hint: 'Select State',
            ),
            const SizedBox(height: 16),

            // District
            _DropdownSection(
              label: '📍 District',
              value: _selectedDistrict,
              items: _selectedState != null ? (locationProvider.districtsByState[_selectedState] ?? []) : [],
              onChanged: (val) {
                setState(() => _selectedDistrict = val);
                locationProvider.setDistrict(val);
              },
              hint: _selectedState == null ? 'Select state first' : 'Select District',
              enabled: _selectedState != null,
            ),
            const SizedBox(height: 24),

            // Quick presets
            const Text('⚡ Quick Select', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickPresets.map((preset) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedState = preset['state'];
                    _selectedDistrict = preset['district'];
                  });
                  locationProvider.setLocation(
                    country: 'India',
                    state: preset['state'],
                    district: preset['district'],
                    city: preset['city'],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedDistrict == preset['district']
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(preset['emoji']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        preset['city']!,
                        style: TextStyle(
                          color: _selectedDistrict == preset['district']
                              ? AppColors.primary
                              : AppColors.text,
                          fontWeight: _selectedDistrict == preset['district']
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() { _selectedState = null; _selectedDistrict = null; });
                      locationProvider.clearLocation();
                      _applyLocation(context, locationProvider);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.divider),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Clear (Global)', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyLocation(context, locationProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _applyLocation(BuildContext context, LocationProvider locationProvider) {
    final trendingProvider = context.read<TrendingProvider>();
    trendingProvider.setLocationFilter(locationProvider.currentFilter);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing trends for ${locationProvider.displayLocation}'),
        backgroundColor: AppColors.rising,
      ),
    );
  }

  static const _quickPresets = [
    {'emoji': '🏙️', 'city': 'Hyderabad', 'state': 'Telangana', 'district': 'Hyderabad'},
    {'emoji': '🌆', 'city': 'Mumbai', 'state': 'Maharashtra', 'district': 'Mumbai'},
    {'emoji': '💻', 'city': 'Bengaluru', 'state': 'Karnataka', 'district': 'Bengaluru Urban'},
    {'emoji': '🏛️', 'city': 'New Delhi', 'state': 'Delhi', 'district': 'New Delhi'},
    {'emoji': '🐟', 'city': 'Chennai', 'state': 'Tamil Nadu', 'district': 'Chennai'},
    {'emoji': '🌊', 'city': 'Kochi', 'state': 'Kerala', 'district': 'Kochi'},
    {'emoji': '🏰', 'city': 'Jaipur', 'state': 'Rajasthan', 'district': 'Jaipur'},
    {'emoji': '🎭', 'city': 'Kolkata', 'state': 'West Bengal', 'district': 'Kolkata'},
  ];
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _DropdownSection extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool enabled;

  const _DropdownSection({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: enabled ? AppColors.divider : AppColors.divider.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint ?? 'Select...', style: const TextStyle(color: AppColors.textSecondary)),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.text),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              isExpanded: true,
              onChanged: enabled ? onChanged : null,
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: AppColors.text)),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
