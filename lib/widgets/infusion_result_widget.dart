import 'package:flutter/material.dart';

class InfusionRateResultWidget extends StatelessWidget {
  const InfusionRateResultWidget({
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
          child: Row(
            children: [
              Text(
                'Saatlik infüzyon hızı:',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Expanded(child: SizedBox()),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: _infusionRate.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextSpan(
                      text: '\nml/saat',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12)
            ],
          ),
        ),
      ),
    );
  }
}
