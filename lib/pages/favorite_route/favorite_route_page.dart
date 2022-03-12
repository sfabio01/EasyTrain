import 'package:easytrain/colors.dart';
import 'package:easytrain/pages/favorite_route/widgets/calendar_row.dart';
import 'package:easytrain/pages/favorite_route/widgets/error_text.dart';
import 'package:easytrain/pages/favorite_route/widgets/my_appbar.dart';
import 'package:easytrain/pages/favorite_route/widgets/solution_card.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteRoutePage extends ConsumerWidget {
  const FavoriteRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionsState = ref.watch(solutionsProvider);

    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: CalendarRow(),
          ),
          Expanded(
            child: solutionsState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryBlue))
                : solutionsState.solutions.fold(
                    () => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ErrorText(),
                    ),
                    (solutions) => ListView.builder(
                      itemCount: solutions.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SolutionCard(solutions[index]),
                          ),
                          if (index == solutions.length - 1 &&
                              !solutionsState.isLast)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(solutionsProvider.notifier)
                                    .getNextSolutions();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: primaryBlue,
                                    size: 16.0,
                                  ),
                                  Text(
                                    "TRENI SUCCESSIVI",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: primaryBlue),
                                  ),
                                  const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: primaryBlue,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
