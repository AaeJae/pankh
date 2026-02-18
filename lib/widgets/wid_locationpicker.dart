import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pankh/constants/app_tokens.dart';

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
      backgroundColor: Colors.transparent,
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
  final _debouncer = Debouncer(milliseconds: 500); // 500ms is the "sweet spot"
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _suggestions = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) {_debouncer.run(() {_fetchSuggestions(query);});} // reduces jank while user types location

  // Fetch suggestions from Nominatim
  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final String targetCities = SupportedCity.allNames;
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search'
              '?q=$query $targetCities' // Search bias
              '&format=json'
              '&addressdetails=1'
              '&countrycodes=in'
              '&limit=15'
      );
      final response = await http.get(url, headers: {'User-Agent': 'Pankh_Bird_App'});
      if (response.statusCode == 200) {
        List<dynamic> rawResults = json.decode(response.body);

        // STRICT FILTER: Only keep results that mention our enum city names
        final filtered = rawResults.where((item) {
          final displayName = item['display_name'].toString().toLowerCase();
          return SupportedCity.values.any((city) =>
              displayName.contains(city.name.toLowerCase())
          );
        }).toList();


        setState(() {
          _suggestions = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Location Search Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // Use 90% of screen height to avoid keyboard overlap
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: AppColors.colPrimary.withValues(alpha:0.9), // Dark theme to match your app
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Grab handle for visual cue
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(2)),
          ),

          // Search Input
          TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter name of locality, city or state",
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              suffixIcon: _isLoading ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)) : null,
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 10),

          // Suggestions List
          Expanded(
            child: ListView.separated(
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                  title: Text(item['display_name'],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    final name = item['display_name'];
                    final lat = double.parse(item['lat']);
                    final lng = double.parse(item['lon']);

                    widget.onLocationSelected(name, lat, lng); // Pass all 3 back!
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