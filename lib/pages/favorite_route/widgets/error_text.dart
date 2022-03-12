import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorText extends ConsumerWidget {
  const ErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionsState = ref.watch(solutionsProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (solutionsState.errorMessage.isNotEmpty)
          Text(
            solutionsState.errorMessage,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: errorColor),
            textAlign: TextAlign.center,
          ),
        TextButton(
          onPressed: () {
            ref.read(solutionsProvider.notifier).getSolutions();
          },
          child: Text(
            "RICARICA",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: primaryBlue),
          ),
        ),
      ],
    );
  }
}
