import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherappv2proj/ex01/screens/subscreens/currently_screen.dart';
import 'package:weatherappv2proj/ex01/screens/subscreens/today_screen.dart';
import 'package:weatherappv2proj/ex01/screens/subscreens/weekly_screen.dart';
import 'package:weatherappv2proj/services/location_service.dart';
import 'package:weatherappv2proj/services/open_meteo_service.dart';
import 'package:weatherappv2proj/widgets/search_field.dart';

class WeatherScreenEx01 extends StatefulWidget {
  const WeatherScreenEx01({super.key});

  @override
  State<WeatherScreenEx01> createState() => _WeatherScreenEx01State();
}

class _WeatherScreenEx01State extends State<WeatherScreenEx01>
    with TickerProviderStateMixin {
  bool isSearchScheduled = false;
  List<Map<String, dynamic>> lastSearchSuggestions = [];

  String searchText = "";
  int screenIndex = 0;
  TabController? controller;

  // TextEditingController textController = TextEditingController();
  final locationService = LocationService.instance;
  final meteoService = OpenMeteoService.instance;

  String displayText = "";

  void onSearchTextSubmitted(text) {
    setState(() {
      searchText = text.trim();
      if (searchText.isNotEmpty) {
        displayText = searchText;
      }
    });
  }

  void onLocationIconPressed() async {
    await initLocationService();
  }

  void onDestinationChanged(index) {
    setState(() {
      screenIndex = index;
    });
    controller?.animateTo(index);
  }

  void onGetWeatherForLocation(double lat, double lng) {
    print("$lat $lng");
  }

  FutureOr<Iterable<Map<String, dynamic>>> onBuildOptions(
      TextEditingValue value) async {
    final trimmed = value.text.trim();
    if (trimmed.isEmpty) return [];
    final suggestions = await meteoService.getGeo(trimmed);
    return suggestions ?? [];
  }

  Future<void> initLocationService() async {
    setState(() {
      displayText = "Getting your location...";
    });
    try {
      final locationData = await locationService.getLocation();
      if (locationData != null) {
        onGetWeatherForLocation(
          locationData.latitude ?? 0,
          locationData.longitude ?? 0,
        );
        setState(() {
          displayText = "${locationData.altitude}, ${locationData.longitude}";
        });
      }
    } catch (e) {
      setState(() {
        displayText = e.toString();
      });
    }
  }

  @override
  void initState() {
    initLocationService();
    controller = TabController(length: 3, vsync: this);
    controller?.addListener(() {
      setState(() {
        screenIndex = controller!.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            titleSpacing: 0,
            title: SearchField(
              optionsBuilder: onBuildOptions,
              onTextChanged: (value) {
                setState(() {
                  searchText = value.trim();
                  displayText = "";
                });
              },
              onTextSubmitted: onSearchTextSubmitted,
              onSelected: (selected) {
                FocusScope.of(context).unfocus();
                onGetWeatherForLocation(
                  selected["latitude"],
                  selected["longitude"],
                );
                print(selected);
              },
            ),
            actions: [
              IconButton(
                onPressed: onLocationIconPressed,
                icon: const Icon(Icons.location_on_rounded),
              ),
            ],
          ),
          body: TabBarView(
            controller: controller,
            children: [
              CurrentlyScreen(
                displayText: displayText,
              ),
              TodayScreen(
                displayText: displayText,
              ),
              WeeklyScreen(
                displayText: displayText,
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: screenIndex,
            onDestinationSelected: onDestinationChanged,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.sunny),
                label: "Currently",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: "Today",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_rounded),
                label: "Weekly",
              ),
            ],
          )),
    );
  }
}
