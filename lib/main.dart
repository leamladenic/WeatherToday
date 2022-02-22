
import 'package:flutter/material.dart';
import 'package:weather_app/data_service.dart';
import 'package:weather_app/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(title: 'Weather App'),
    );
  }
}

Color baseColor = Color(0XFF094507);
String imagePath = "images/backgorund.jpg";
//Color(0XFF094507);

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<WeatherApp> createState() => _MyWeatherApp();
}

class _MyWeatherApp extends State<WeatherApp> {
  TextEditingController _cityTextController = TextEditingController();
  final _dataService = DataService();
  String initialText = "";

  WeatherResponse _response;

  @override
  void initState() {
    super.initState();
    _cityTextController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _cityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: baseColor,
      toolbarHeight: 80.0,
      elevation: 1.0,
      title: Image.asset(
        'images/logo.png',
        fit: BoxFit.contain,
        width: 240.0,
      ),
    );

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 20, color: baseColor),
      primary: baseColor,
    );

    final body = Center(
      child: Container(
        color: baseColor.withOpacity(0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_response != null)
              Padding(
                padding: EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 45.0),
                child: Column(
                  children: [
                    Text(
                      '${_response.tempInfo.temperature}°C',
                      style: TextStyle(fontSize: 55, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          _response.iconUrl,
                          color: Colors.white,
                          height: 50.0,
                        ),
                        Text(
                          _response.weatherInfo.description.toUpperCase(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 35.0),
              //padding: EdgeInsets.fromLTRB(35.0, 1.0, 35.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _cityTextController,
                    onSubmitted: (newValue) {
                      setState(() {
                        initialText = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: TextStyle(
                          color: baseColor, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: baseColor, width: 2.0),
                      ),
                      labelText: 'Enter city',
                    ),
                    minLines: 1,
                    maxLines: 1,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
                    child: SizedBox(
                      width: 180.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _search,
                        child: const Text('Lets go!'),
                        style: style,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    final weather = response.weatherInfo.description;

    if (weather.contains("snow")) {
      imagePath = "images/snow.jpg";
      baseColor = Color(0XFF6F8FAF);
    } else if (weather.contains("sun")) {
      baseColor = Color(0XFFdb7093);
      imagePath = "images/sunny.jpg";
    } else if (weather.contains("cloud")) {
      baseColor = Color(0XFF4682B4);
      imagePath = "images/cloudy.jpg";
    } else if (weather.contains("thunder")) {
      imagePath = "images/thunder.jpg";
      baseColor = Color(0XFF722f37);
    } else if (weather.contains("rain") || weather.contains("drizzle")) {
      imagePath = "images/rain.jpg";
      baseColor = Color(0XFF7393B3);
    } else if (weather.contains("clear") &&
        response.tempInfo.temperature < 10.0) {
      imagePath = "images/clearCold.jpg";
      baseColor = Color(0XFF6495ED);
    } else if (weather.contains("clear")) {
      imagePath = "images/clear.jpg";
      baseColor = Color(0XFFff91af);
    } else {
      imagePath = "images/fog.jpg";
      baseColor = Color(0XFF008080);
    }

    setState(() => _response = response);
  }
}
