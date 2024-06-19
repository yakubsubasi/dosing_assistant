import 'package:dosing_assistant/data.dart';
import 'package:dosing_assistant/second_test_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrugDosagePage2(dose: dobutamineInfusion),
    );
  }
}

class DrugDosagePage extends StatefulWidget {
  const DrugDosagePage({Key? key, required this.dose}) : super(key: key);

  final DosingModel dose;

  @override
  State<DrugDosagePage> createState() => _DrugDosagePageState();
}

class _DrugDosagePageState extends State<DrugDosagePage> {
  int _selectedDilutionVolume = 100; // Default value

  double get _infusionRate {
    return _selectedDilutionVolume /
        (widget.dose.drugAmount /
            widget.dose.applications[0].infusionRateValue);
  }

  void _onDilutionVolumeChanged(int? newValue) {
    setState(() {
      _selectedDilutionVolume = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.dose.name),
              floating: true,
            ),
            SliverToBoxAdapter(
                child: Text(
              'Drug: ${widget.dose.drugName} ${widget.dose.drugAmount} ${widget.dose.unit.toString().split('.').last}',
            )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors.lightBlue[100 * (index + 1 % 9)],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DilutionVolumeSelectingWidget(
                              onDilutionVolumeChanged: _onDilutionVolumeChanged,
                            ),
                            InfusionDoseResultWidget(
                                infusionDose: _infusionRate),
                            WeightPicker(
                              initialValue: 70,
                              onValueChanged: (int value, String unit) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                childCount: widget.dose.applications.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfusionDoseResultWidget extends StatelessWidget {
  const InfusionDoseResultWidget({
    super.key,
    required double infusionDose,
  }) : _infusionRate = infusionDose;

  final double _infusionRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 212, 184, 184),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Infusion dose: ${_infusionRate.toStringAsFixed(2)} cc/h',
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

class DilutionVolumeSelectingWidget extends StatefulWidget {
  const DilutionVolumeSelectingWidget(
      {Key? key, required this.onDilutionVolumeChanged})
      : super(key: key);

  final ValueChanged<int?> onDilutionVolumeChanged;

  @override
  State<DilutionVolumeSelectingWidget> createState() =>
      _DilutionVolumeSelectingWidgetState();
}

class _DilutionVolumeSelectingWidgetState
    extends State<DilutionVolumeSelectingWidget> {
  int _selectedValue = 100; // Default value
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(Icons.medication_liquid),
                  ), // Replace with your preferred icon
                  Center(
                      child: Text('Dilüasyon sıvısını seçin',
                          textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: CupertinoSegmentedControl<int>(
              groupValue: _selectedValue,
              children: const <int, Widget>{
                100: Text('100 cc'),
                250: Text('250 cc'),
                500: Text('500 cc'),
                1000: Text('1000 cc'),
              },
              onValueChanged: (int value) {
                setState(() {
                  _selectedValue = value;
                  widget.onDilutionVolumeChanged(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PatientWeightSelectionWidget extends StatelessWidget {
  const PatientWeightSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.person),
                Text(
                  'Hastanın kilosunu seçin',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: CupertinoSegmentedControl<int>(
              children: const <int, Widget>{
                1: Text('50 kg'),
                2: Text('60 kg'),
                3: Text('70 kg'),
                4: Text('80 kg'),
                5: Text('90 kg'),
                6: Text('100 kg'),
              },
              onValueChanged: (int? newValue) {
                // Handle segment change
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeightPicker extends StatefulWidget {
  final Function(int, String) onValueChanged;
  final int initialValue;

  const WeightPicker(
      {super.key, required this.onValueChanged, required this.initialValue});

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late int _currentValue;
  late String _currentUnit;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _currentUnit = 'kg';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Patient\'s weight',
                style: Theme.of(context).textTheme.bodyLarge),
            Row(
              children: [
                Text(
                  _currentValue.toString(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(
                  width: 12,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentUnit,
                    items: <String>['kg', 'lb']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentUnit = newValue!;
                        widget.onValueChanged(_currentValue, _currentUnit);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Slider(
          thumbColor: Theme.of(context).colorScheme.secondary,
          allowedInteraction: SliderInteraction.tapAndSlide,
          value: _currentValue.toDouble(),
          min: 40,
          max: 200,
          divisions: 80,
          onChanged: (double newValue) {
            setState(() {
              _currentValue = newValue.round();
              widget.onValueChanged(_currentValue, _currentUnit);
            });
          },
        ),
      ],
    );
  }
}
