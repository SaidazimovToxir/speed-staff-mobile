import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/widgets/vacancies_list_view.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/widgets/my_vacancies_app_bar.dart';

class MyVacanciesScreen extends StatelessWidget {
  const MyVacanciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.cF6F6F6,
        appBar: const MyVacanciesAppBar(),
        body: BlocBuilder<VacanciesBloc, VacanciesState>(
          builder: (context, state) {
            switch (state.status) {
              case VacanciesStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.c1F3C88),
                );
              case VacanciesStatus.success:
                final vacancies = state.vacancies;
                return TabBarView(
                  children: [
                    VacanciesListView(vacancies: vacancies),
                    const Center(
                      child: CustomText(text: "Finished vacancies list"),
                    ),
                    const Center(
                      child: CustomText(text: "Closed vacancies list"),
                    ),
                  ],
                );
              case VacanciesStatus.failure:
                return Center(
                  child: CustomText(
                    text: "Error: ${state.errorMessage}",
                    color: AppColors.cFF0000,
                  ),
                );
              default:
                return const Center(
                  child: CustomText(text: "No vacancies found"),
                );
            }
          },
        ),
      ),
    );
  }
}
