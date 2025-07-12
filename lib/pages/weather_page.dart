import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/service/weather_service.dart';
import 'package:lottie/lottie.dart';
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('d5a0ef63a242ed6673e8e330e8bb8a0c');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // fetch weather data
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
  }
  
  // handle errors
  catch (e) {
    print(e);
  }
}

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/rainy.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; // default animation 
    }
  }


  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather data when the page is initialized / startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? 'Loading City...'),

            // animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()}°C'),

            // weather condition
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
