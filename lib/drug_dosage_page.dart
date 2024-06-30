import 'package:dosing_assistant/data.dart';
import 'package:dosing_assistant/dosing_assistant/widgets/infusion_rate_picker.dart';
import 'package:dosing_assistant/dosing_assistant/widgets/infusion_result_widget.dart';
import 'package:dosing_assistant/dosing_assistant/widgets/segmented_dilution_solution_picker.dart';
import 'package:dosing_assistant/dosing_assistant/widgets/weight_picker.dart';
import 'package:flutter/material.dart';

class DrugDosagePage extends StatefulWidget {
  const DrugDosagePage({Key? key, required this.dose}) : super(key: key);

  final DosingModel dose;

  @override
  State<DrugDosagePage> createState() => _DrugDosagePageState();
}

class _DrugDosagePageState extends State<DrugDosagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dose.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  widget.dose.applications.length,
                  (index) => DrugDosageListItem(
                    dose: widget.dose.applications[index],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrugDosageListItem extends StatefulWidget {
  final ApplicationModel dose;

  const DrugDosageListItem({
    Key? key,
    required this.dose,
  }) : super(key: key);

  @override
  State<DrugDosageListItem> createState() => _DrugDosageListItemState();
}

class _DrugDosageListItemState extends State<DrugDosageListItem> {
  int _dilutionVolume = 100;
  int _weight = 70;
  late double _infusionRate;

  @override
  void initState() {
    _infusionRate = widget.dose.infusionRateValue;
    super.initState();
  }

  void _onDilutionVolumeChanged(int? newValue) {
    setState(() {
      _dilutionVolume = newValue!;
    });
  }

  void _onWeightChanged(int newValue, String unit) {
    setState(() {
      _weight = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double infusionResult = widget.dose.dose(
        weight: _weight,
        infusion: _infusionRate,
        dilutionVolume: _dilutionVolume);

    final drug = widget.dose.drug;
    final dose = widget.dose;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İlaç: ${dose.drug.fullName()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfusionRateSelectingWidget(
                  dose: dose,
                  onChanged: (value) => setState(() => _infusionRate = value),
                  initialInfusionRate: _infusionRate,
                ),
                if (dose.infusionRateUnit == 'mcg/kg/min')
                  const Divider(
                    height: 40,
                  ),
                if (dose.infusionRateUnit == 'mcg/kg/min')
                  WeightPicker(
                    initialValue: _weight,
                    onValueChanged: _onWeightChanged,
                  ),
                const Divider(
                  height: 40,
                ),
                SegmentedDilutionVolumeSelectingWidget(
                  drug: drug,
                  solutionType: dose.solutionType,
                  onDilutionVolumeChanged: _onDilutionVolumeChanged,
                  selectedValue: _dilutionVolume,
                ),
                const Divider(
                  height: 40,
                ),
                InfusionRateResultWidget(infusionDose: infusionResult),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DilutionVolumeSelectingWidget extends StatefulWidget {
  final ValueChanged<int?> onDilutionVolumeChanged;
  final int selectedValue;
  final String solutionType;
  final Drug drug;

  const DilutionVolumeSelectingWidget({
    Key? key,
    required this.drug,
    required this.onDilutionVolumeChanged,
    required this.selectedValue,
    required this.solutionType,
  }) : super(key: key);

  @override
  State<DilutionVolumeSelectingWidget> createState() =>
      _DilutionVolumeSelectingWidgetState();
}

class _DilutionVolumeSelectingWidgetState
    extends State<DilutionVolumeSelectingWidget> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Mayi:', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedValue,
                items: const <DropdownMenuItem<int>>[
                  DropdownMenuItem<int>(
                    value: 100,
                    child: Text('100 cc'),
                  ),
                  DropdownMenuItem<int>(
                    value: 250,
                    child: Text('250 cc'),
                  ),
                  DropdownMenuItem<int>(
                    value: 500,
                    child: Text('500 cc'),
                  ),
                  DropdownMenuItem<int>(
                    value: 1000,
                    child: Text('1000 cc'),
                  ),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                    widget.onDilutionVolumeChanged(newValue);
                  });
                },
              ),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(text: '* '),
              TextSpan(
                  text:
                      '${_selectedValue - widget.drug.volume!} ml ${widget.solutionType} ',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '+ 1 ampul '),
              TextSpan(
                  text: widget.drug.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' şeklinde hazırlanan mayi')
            ],
          ),
        )
      ],
    );
  }
}
