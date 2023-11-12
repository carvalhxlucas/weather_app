import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/services/weather_services.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('1fae7e3583c3e393d126be8868e1d068');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get city
    String cityName = await _weatherService.getCurrentCity();

    //get weather from the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // city name
              Text(
                _weather?.cityName ?? "loading city...",
                style: const TextStyle(
                    fontFamily: 'Heavitas', fontSize: 25, color: Colors.white, letterSpacing: 1.0),
              ),

              // animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // temperature
              Text(
                '${_weather?.temperature?.round() ?? "loading temperature"}ºC',
                style: const TextStyle(
                    fontFamily: 'Heavitas', fontSize: 25, color: Colors.white, letterSpacing: 1.0),
              ),
              Text(' '),

              // weather condition
              Text(
                _weather?.mainCondition ?? "",
                style: const TextStyle(
                    fontFamily: 'Heavitas', fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
