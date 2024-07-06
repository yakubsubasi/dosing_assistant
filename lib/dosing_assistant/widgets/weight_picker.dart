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
                  width: 8,
                ),
                Text('kg', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        Slider(
          allowedInteraction: SliderInteraction.tapAndSlide,
          value: _currentValue.toDouble(),
          min: 30,
          max: 180,
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
