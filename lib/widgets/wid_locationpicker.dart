import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pankh/constants/appDesignSystem.dart'; // Unified Barrel File

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class WidLocationPicker extends StatefulWidget {
  final Function(String name, double lat, double lng) onLocationSelected;
  const WidLocationPicker({super.key, required this.onLocationSelected});

  static void showLocationBottomModal(BuildContext context, Function(String typedLocation, double lat, double lng) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Required for our custom container shape
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: WidLocationPicker(onLocationSelected: onSelected),
      ),
    );
  }

  @override
  State<WidLocationPicker> createState() => _WidLocationPickerState();
}

class _WidLocationPickerState extends State<WidLocationPicker> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<dynamic> _suggestions = [];
  bool _isLoading = false;

  Future<void> _onSearchChanged(String query) async {
    if (query.length < 3) {
      setState(() => _suggestions = []);
      return;
    }

    _debouncer.run(() async {
      setState(() => _isLoading = true);
      try {
        final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          setState(() {
            _suggestions = json.decode(response.body);
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Optimized for mobile: uses screenEdge and radiusMedium
      padding: const EdgeInsets.all(AppSizes.screenEdge),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.colPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.sizeSmall),
        ),
      ),
      child: Column(
        children: [
          // 1. Drag Handle for UI consistency
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.colWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.sizeCircular),
            ),
          ),
          const SizedBox(height: AppSizes.sizeMedium),

          // 2. Optimized Search Field
          TextField(
            style: AppTypography.body.copyWith(color: AppColors.colWhite),
            cursorColor: AppColors.colTertiary,
            decoration: InputDecoration(
              hintText: "Search for a city...",
              hintStyle: AppTypography.body.copyWith(color: AppColors.colWhite.withOpacity(0.5)),
              prefixIcon: const Icon(Icons.search, color: AppColors.colTertiary),
              filled: true,
              fillColor: AppColors.colWhite.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.sizeXSmall),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _isLoading
                  ? const Padding(
                  padding: EdgeInsets.all(AppSizes.sizeXSmall),
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.colTertiary)
              )
                  : null,
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: AppSizes.sizeSmall),

          // 3. Results List
          Expanded(
            child: ListView.separated(
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.colWhite.withOpacity(0.05),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined, color: AppColors.colTertiary),
                  title: Text(
                    item['display_name'],
                    style: AppTypography.body.copyWith(color: AppColors.colWhite),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    final name = item['display_name'].split(',')[0]; // Simplify name
                    final lat = double.parse(item['lat']);
                    final lng = double.parse(item['lon']);
                    widget.onLocationSelected(name, lat, lng);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
