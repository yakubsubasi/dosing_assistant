import 'package:dosing_assistant/data.dart';
import 'package:dosing_assistant/main.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DrugDosagePage2 extends StatefulWidget {
  const DrugDosagePage2({Key? key, required this.dose}) : super(key: key);

  final DosingModel dose;

  @override
  State<DrugDosagePage2> createState() => _DrugDosagePage2State();
}

class _DrugDosagePage2State extends State<DrugDosagePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dose.name),
      ),
      body: ListView.builder(
        itemCount: widget.dose.applications.length,
        itemBuilder: (context, index) {
          return DrugDosageListItem(
            dose: widget.dose.applications[index],
          );
        },
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

    return ListTile(
      title: Text(
        'İlaç: ${drug.name} ${drug.amount} ${drug.unit}${drug.volume != null ? ' / ${drug.volume} ml' : ''}',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          //InfusionRateWidget
          Text('İnfüzyon dozu: $_infusionRate ${dose.infusionRateUnit}'),
          SfSlider(
            value: _infusionRate,
            min: dose.minInfisionRate,
            max: dose.maxInfisionRate,
            minorTicksPerInterval: 0,
            tooltipTextFormatterCallback:
                (dynamic value, String formattedText) {
              return '${value.toStringAsFixed(2)} ${dose.infusionRateUnit}';
            },
            interval: 3,
            stepSize: 3,
            showDividers: true,
            enableTooltip: true,
            showTicks: true,
            showLabels: true,
            onChanged: (value) =>
                setState(() => _infusionRate = value.toDouble()),
          ),
          const Divider(),
          DilutionVolumeSelectingWidget(
            onDilutionVolumeChanged: _onDilutionVolumeChanged,
            selectedValue: _dilutionVolume,
          ),
          const Divider(),
          WeightPicker(
            initialValue: _weight,
            onValueChanged: _onWeightChanged,
          ),
          const Divider(),
          InfusionDoseResultWidget(infusionDose: infusionResult),
        ],
      ),
    );
  }
}

class DilutionVolumeSelectingWidget extends StatefulWidget {
  final ValueChanged<int?> onDilutionVolumeChanged;
  final int selectedValue;

  const DilutionVolumeSelectingWidget({
    Key? key,
    required this.onDilutionVolumeChanged,
    required this.selectedValue,
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
    return Row(
      children: [
        const Text('Mayi:'),
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
        const SizedBox(width: 4),
        const Text('SF içerisinde'),
      ],
    );
  }
}
