import 'package:flutter/material.dart';
import 'package:weatherappv2proj/ex00/screens/subscreens/currently_screen.dart';
import 'package:weatherappv2proj/ex00/screens/subscreens/today_screen.dart';
import 'package:weatherappv2proj/ex00/screens/subscreens/weekly_screen.dart';
import 'package:weatherappv2proj/services/location_service.dart';

class WeatherScreenEx00 extends StatefulWidget {
  const WeatherScreenEx00({super.key});

  @override
  State<WeatherScreenEx00> createState() => _WeatherScreenEx00State();
}

class _WeatherScreenEx00State extends State<WeatherScreenEx00>
    with TickerProviderStateMixin {
  String searchText = "";
  int screenIndex = 0;
  TabController? controller;
  TextEditingController textController = TextEditingController();
  final locationService = LocationService.instance;

  String displayText = "";

  void onSearchTextSubmitted(text) {
    setState(() {
      searchText = text.trim();
      if (searchText.isNotEmpty) {
        displayText = searchText;
      }
    });
  }

  void onLocationIconPressed() {
    initLocationService();
    // setState(() {
    //   displayText = "Geolocation";
    // });
  }

  void onDestinationChanged(index) {
    setState(() {
      screenIndex = index;
    });
    controller?.animateTo(index);
  }

  void initLocationService() async {
    setState(() {
      displayText = "Getting your location...";
    });
    try {
      final locationData = await locationService.getLocation();
      if (locationData != null) {
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
            title: TextField(
              controller: textController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (text) {
                setState(() {
                  searchText = text.trim();
                  displayText = "";
                });
              },
              onSubmitted: onSearchTextSubmitted,
              decoration: InputDecoration(
                hintText: "Search locations",
                border: InputBorder.none,
                suffixIcon: textController.text.isNotEmpty
                    ? IconButton(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100),
                        onPressed: () {
                          setState(() {
                            searchText = "";
                            displayText = "";
                          });
                          textController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded, size: 20),
                      )
                    : null,
              ),
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
