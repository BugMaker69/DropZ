import 'dart:convert';
import 'package:drop_z_ecommerce_app/features/address/data/model/city.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/governorate.dart';
import 'package:flutter/services.dart';

class AddressService {
  static Future<List<Governorate>> loadGovernorates() async {
    final data = await rootBundle.loadString('assets/data/governorates.json');
    final jsonResult = json.decode(data);

    final list = jsonResult[2]['data'] as List;
    return list.map((e) => Governorate.fromJson(e)).toList();
  }

  static Future<List<City>> loadCities() async {
    final data = await rootBundle.loadString('assets/data/cities.json');
    final jsonResult = json.decode(data);

    final list = jsonResult[2]['data'] as List;
    return list.map((e) => City.fromJson(e)).toList();
  }
}
