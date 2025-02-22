import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talabat/core/cubit/sectioncubit.dart';
import 'package:talabat/utils/constants.dart';
import 'package:talabat/utils/theme.dart';
import 'package:talabat/widgets/categorycard.dart';

class Categoriesbottomsheet extends StatelessWidget {
  const Categoriesbottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      margin: const EdgeInsets.only(top: 240),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        children: [
          // Handle the drag handle
          SizedBox(
            height: 10,
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Adding a Scrollable List View
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust height dynamically
            child: BlocProvider(
              create: (_) => GetIt.I<SectionCubit>()..fetchSections(),
              child: BlocBuilder<SectionCubit, SectionState>(
                builder: (context, state) {
                  final cubit = context.read<SectionCubit>();

                  if (state.sections.isEmpty && state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !state.isLoading) {
                          cubit.fetchSections();
                        }
                        return true;
                      },
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10, // Horizontal space between items
                        runSpacing: 10, // Vertical space between items
                        children: [
                          ...List.generate(state.sections.length, (index) {
                            return CategoryCard(section: state.sections[index]);
                          }),
                        ],
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
