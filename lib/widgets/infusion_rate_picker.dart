import 'package:dosing_assistant/data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class InfusionRateSelectingWidget extends StatefulWidget {
  final ApplicationModel dose;
  final Function(double) onChanged;
  final double initialInfusionRate;

  const InfusionRateSelectingWidget({
    Key? key,
    required this.dose,
    required this.onChanged,
    required this.initialInfusionRate,
  }) : super(key: key);

  @override
  State<InfusionRateSelectingWidget> createState() =>
      _InfusionRateSelectingWidgetState();
}

class _InfusionRateSelectingWidgetState
    extends State<InfusionRateSelectingWidget> {
  late double _infusionRate;

  @override
  void initState() {
    super.initState();
    _infusionRate = widget.initialInfusionRate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Hedef infüzyon dozu:',
                style: Theme.of(context).textTheme.bodyLarge),
            const Expanded(child: SizedBox()),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: _infusionRate.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextSpan(
                      text: '\n${widget.dose.infusionRateUnit}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SfSlider(
          value: _infusionRate,
          min: widget.dose.minInfisionRate,
          max: widget.dose.maxInfisionRate,
          minorTicksPerInterval: 0,
          tooltipTextFormatterCallback: (dynamic value, String formattedText) {
            return '${value.toStringAsFixed(1)} ${widget.dose.infusionRateUnit}';
          },
          interval: widget.dose.tooMuchInterval() ? 10 : widget.dose.interval,
          stepSize: widget.dose.interval,
          showDividers: true,
          enableTooltip: true,
          showTicks: true,
          showLabels: true,
          onChanged: (value) {
            setState(() => _infusionRate = value.toDouble());
            widget.onChanged(_infusionRate);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.dose.infusionTips.length, (index) {
            return Text('* ${widget.dose.infusionTips[index]}');
          }),
        )
      ],
    );
  }
}
