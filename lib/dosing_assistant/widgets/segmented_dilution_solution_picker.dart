import 'package:dosing_assistant/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedDilutionVolumeSelectingWidget extends StatefulWidget {
  final ValueChanged<int?> onDilutionVolumeChanged;
  final int selectedValue;
  final String solutionType;
  final Drug drug;

  const SegmentedDilutionVolumeSelectingWidget({
    Key? key,
    required this.drug,
    required this.onDilutionVolumeChanged,
    required this.selectedValue,
    required this.solutionType,
  }) : super(key: key);

  @override
  State<SegmentedDilutionVolumeSelectingWidget> createState() =>
      _SegmentedDilutionVolumeSelectingWidgetState();
}

class _SegmentedDilutionVolumeSelectingWidgetState
    extends State<SegmentedDilutionVolumeSelectingWidget> {
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
            Expanded(
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
        const SizedBox(
          height: 24,
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
              const TextSpan(text: ' ile mayi hazırlanır')
            ],
          ),
        )
      ],
    );
  }
}
