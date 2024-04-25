import 'dart:convert';

import 'package:adrplexus/helper/appstring.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class DataCubit extends Cubit<DataState> {
  
  DataCubit() : super(DataInitial());

  Future<void> fetchData() async {
    try {
      final response1 = await http.get(Uri.parse(AppString.BASE_URL1));
      final response2 = await http.get(Uri.parse(AppString.BASE_URL2));
      
      
      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> data1 = jsonDecode(response1.body);
        final List<dynamic> data2 = jsonDecode(response2.body);
        
        List<DataModel> combinedData = [];

        for (var item in data1) {
          combinedData.add(DataModel.fromJson(item));
        }

        for(var item2 in data2){
        combinedData.add(DataModel.fromJson(item2));
        }

        emit(DataLoaded(combinedData));
      } else {
        emit(DataError());
      }
    } catch (e) {
      print(e.toString());
      emit(DataError());
    }
  }
}

class DataModel {
  String? gender;
  String? user;

  DataModel({  this.gender, this.user});
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      gender: json['gender'],
      user: json['user']

    );
  }
}

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoaded extends DataState {
  final List<DataModel> items;

  DataLoaded(this.items);
}

class DataError extends DataState {}
