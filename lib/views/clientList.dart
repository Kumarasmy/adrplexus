import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cubit Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => DataCubit(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataCubit dataCubit = BlocProvider.of<DataCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Cubit Example'),
      ),
      body: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          if (state is DataInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Name: ${state.items[index].name}, Age: ${state.items[index].age}'),
                );
              },
            );
          } else if (state is DataError) {
            return Center(
              child: Text('Failed to fetch data'),
            );
          } else {
            return Container(); // Handle other states if needed
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dataCubit.fetchData();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  Future<void> fetchData() async {
    try {
      final response1 = await http.get(Uri.parse('API_ENDPOINT_1'));
      final response2 = await http.get(Uri.parse('API_ENDPOINT_2'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> data1 = jsonDecode(response1.body);
        final List<dynamic> data2 = jsonDecode(response2.body);

        List<DataModel> combinedData = [];

        data1.forEach((item) {
          combinedData.add(DataModel.fromJson(item));
        });

        data2.forEach((item) {
          combinedData.add(DataModel.fromJson(item));
        });

        emit(DataLoaded(combinedData));
      } else {
        emit(DataError());
      }
    } catch (e) {
      emit(DataError());
    }
  }
}

class DataModel {
  final String name;
  final int age;

  DataModel({required this.name, required this.age});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'],
      age: json['age'],
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
