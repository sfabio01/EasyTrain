import 'package:easytrain/colors.dart';
import 'package:easytrain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StationType {
  departure,
  destination,
}

class SelectStationPage extends ConsumerStatefulWidget {
  final StationType type;
  const SelectStationPage(this.type, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectStationPageState();
}

class _SelectStationPageState extends ConsumerState<SelectStationPage> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stationsState = ref.watch(stationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyTrain"),
        centerTitle: true,
        backgroundColor: darkBlue,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textController,
                onChanged: (value) {
                  ref.read(stationsProvider.notifier).updateQuery(value);
                },
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: calendarTextColor, fontSize: 20.0),
                cursorColor: primaryBlue,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.train_rounded,
                      color: calendarTextColor,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryBlue, width: 2.0)),
                    hintText: widget.type == StationType.departure
                        ? "STAZIONE DI PARTENZA"
                        : "STAZIONE DI DESTINAZIONE"),
              ),
            ),
            stationsState.isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : stationsState.stations.fold(() {
                    if (stationsState.errorMessage.isNotEmpty) {
                      return Center(
                        child: Text(stationsState.errorMessage),
                      );
                    } else {
                      return const Center(
                        child: Text("Cerca una stazione"),
                      );
                    }
                  }, (list) {
                    return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  if (widget.type == StationType.departure) {
                                    ref
                                        .read(routeProvider.notifier)
                                        .changeDeparture(list[index]);
                                  } else {
                                    ref
                                        .read(routeProvider.notifier)
                                        .changeDestination(list[index]);
                                  }
                                  _textController.text = "";
                                  ref.read(stationsProvider.notifier).reset();
                                },
                                child: ListTile(
                                  title: Text(list[index]),
                                ),
                              ),
                          separatorBuilder: (context, _) => const Divider(),
                          itemCount: list.length),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
