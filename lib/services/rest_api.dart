import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:we_healthy/services/wehealthy_services.dart';
import 'dart:convert';
import 'package:we_healthy/utils/config.dart';
import 'package:geolocator/geolocator.dart';

class RestApi {
  late Random random = Random();

  Future<List<double>> getLocationUser() async {
    List<double> _koorLocation = [];
    double? _lat;
    double? _long;
    Position? _currentPosition;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) => {_currentPosition = position});
      _lat = _currentPosition?.latitude;
      _long = _currentPosition?.longitude;

      _koorLocation.add(_lat!);
      _koorLocation.add(_long!);

      return _koorLocation;
    } catch (e) {
      print(e);
    }

    return _koorLocation;
  }

  Future<String> getCurrentLocationUser() async {
    late String? location;
    late String? city;
    late String? province;

    List<double> koordinat = await getLocationUser();
    double latitude = koordinat[0];
    double longitude = koordinat[1];
    String url =
        "https://api.api-ninjas.com/v1/reversegeocoding?lat=$latitude&lon=$longitude&X-Api-Key=$apiKeyNinjas";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        city = decodedData[0]['name'];
        province = decodedData[0]['state'];
        location = "$city, $province";
        print(location);
        return location;
      }
    } catch (e) {
      print(e);
    }

    return location = '-';
  }

  Future<double> getCurrentWeather() async {
    late double? kelvin;
    List<double> koordinat = await getLocationUser();
    double latitude = koordinat[0];
    double longitude = koordinat[1];
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikeyOpenWeather";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        kelvin = decodedData['main']['temp'];
        print(kelvin);
        return kelvin!;
      } else {}
    } catch (e) {}

    return kelvin = 0;
  }

  Future<int> getAirPollution() async {
    late int? indexAqi;
    List<double> koordinat = await getLocationUser();
    double latitude = koordinat[0];
    double longitude = koordinat[1];
    String url =
        "https://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$apikeyOpenWeather";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        indexAqi = decodedData['list'][0]['main']['aqi'];
        print(indexAqi);
        return indexAqi!;
      } else {}
    } catch (e) {}

    return indexAqi = 0;
  }

  Future<Map<String, dynamic>> fetchDataFood() async {
    Map<String, dynamic> tempDataFood = await WehealthyLogic().foodList();
    Map<String, dynamic> nullReturn = {'null': true};

    int randFatsIndex = random.nextInt(14);
    int randProteinIndex = random.nextInt(14);
    int randCarbsIndex = random.nextInt(14);

    String foodFats = tempDataFood['fats'][randFatsIndex];
    String foodProtein = tempDataFood['protein'][randProteinIndex];
    String foodCarbs = tempDataFood['carbs'][randCarbsIndex];

    String apiUrlForFats =
        "https://api.api-ninjas.com/v1/nutrition?query=$foodFats&X-Api-Key=$apiKeyNinjas";
    String apiUrlForProtein =
        "https://api.api-ninjas.com/v1/nutrition?query=$foodProtein&X-Api-Key=$apiKeyNinjas";
    String apiUrlForCarbs =
        "https://api.api-ninjas.com/v1/nutrition?query=$foodCarbs&X-Api-Key=$apiKeyNinjas";

    try {
      final responseCarbs = await http.get(Uri.parse(apiUrlForCarbs));
      final responseFats = await http.get(Uri.parse(apiUrlForFats));
      final responseProtein = await http.get(Uri.parse(apiUrlForProtein));

      if (responseCarbs.statusCode == 200 &&
          responseFats.statusCode == 200 &&
          responseProtein.statusCode == 200) {
        final decodedDataCarbs = json.decode(responseCarbs.body);
        final decodedDataFats = json.decode(responseFats.body);
        final decodedDataProtein = json.decode(responseProtein.body);

        Map<String, dynamic> foodData = {
          "carbs": {
            "name": decodedDataCarbs[0]['name'],
            "calories": decodedDataCarbs[0]['calories'],
            "serving_size_g": decodedDataCarbs[0]['serving_size_g'],
          },
          "protein": {
            "name": decodedDataFats[0]['name'],
            "calories": decodedDataFats[0]['calories'],
            "serving_size_g": decodedDataFats[0]['serving_size_g'],
          },
          "fats": {
            "name": decodedDataProtein[0]['name'],
            "calories": decodedDataProtein[0]['calories'],
            "serving_size_g": decodedDataProtein[0]['serving_size_g'],
          },
        };

        return foodData;
      } else {
        print('Failed to load data. Status code: ${responseCarbs.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return nullReturn;
  }
}