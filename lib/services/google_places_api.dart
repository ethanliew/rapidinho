import 'dart:async';
import 'package:rapidinho/keys/google_places_api_key.dart';
import 'package:rapidinho/model/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GooglePlacesApi {
  final Duration delay;
  const GooglePlacesApi([this.delay = const Duration(milliseconds: 3000)]);

  Future<List<Result>> getPlaces() async {
    List<Result> nearByPlaces = [];
    http.Response response = await http.get(url, headers: {"Accept": "application/json"}).catchError((resp){});
    List list = json.decode(response.body)['results'];
    for(var place in list) {
      Result result = Result(name: place['name'], rating: place["rating"]);
      nearByPlaces.add(result);
    }
    return nearByPlaces;
  }

  Future<List<Photo>> getPhotos(String placeId) async {
    List<Photo> placePhotos = [];
    http.Response response = await http.get(detailUrl+placeId+'&fields=photos&key=$key', headers: {"Accept": "application/json"}).catchError((resp){});
    Map photos = json.decode(response.body)['result'];
    photos.forEach((f, ff){
      List photos = ff;
      photos.forEach((pho){
        Photo result = Photo(photoReference: pho['photo_reference'], height: pho["height"], width: pho["width"]);
        placePhotos.add(result);
      });
    });
    return placePhotos;
  }
}