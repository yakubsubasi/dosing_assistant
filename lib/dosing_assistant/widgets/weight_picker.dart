import 'package:flutter/material.dart';

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
            Text('Hastanın Vücut Ağırlığı:',
                style: Theme.of(context).textTheme.bodyLarge),
            Row(
              children: [
                Text(
                  _currentValue.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text('kg'),
                //   DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       value: _currentUnit,
                //       items: <String>['kg', 'lb']
                //           .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           _currentUnit = newValue!;
                //           widget.onValueChanged(_currentValue, _currentUnit);
                //         });
                //       },
                //     ),
                //   ),
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
