import 'package:adrplexus/controller/listController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataCubit dataCubit = BlocProvider.of<DataCubit>(context);
    dataCubit.fetchData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdrPlexus'),
      ),
      body: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          if (state is DataInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataLoaded) {
            return ListView.separated(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('UserID: ${state.items[index].user ?? "No Data" } , Gender: ${state.items[index].gender ?? "No Data"}'),
                );
              },
            separatorBuilder: (context, index) {
    return Divider();
  },
              );
          } else if (state is DataError) {
            return const Center(
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
        child: const Icon(Icons.refresh),
      ),
    );
  }
}