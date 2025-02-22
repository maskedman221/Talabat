import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/storecubit.dart';
import 'package:talabat/widgets/storecard.dart';

class StoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Stores'),
      ),
      body: BlocProvider(
        create: (_) => GetIt.I<StoreCubit>()..fetchStores(),
        child: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            final cubit = context.read<StoreCubit>();

            if (state.stores.isEmpty && state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !state.isLoading) {
                  cubit.fetchStores();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: state.stores.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.stores.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final store = state.stores[index];
                  return StoreCard(store: store);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
