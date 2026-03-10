import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/widgets/vacancy_item_card.dart';

class VacanciesListView extends StatelessWidget {
  final List<VacancyEntity> vacancies;
  const VacanciesListView({super.key, required this.vacancies});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: vacancies.length,
      separatorBuilder: (context, index) => 16.g,
      itemBuilder: (context, index) =>
          VacancyItemCard(vacancy: vacancies[index]),
    );
  }
}
