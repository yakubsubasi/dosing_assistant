// ignore_for_file: public_member_api_docs, sort_constructors_first
enum ApplicationType { bolus, infusion }

enum DrugUnit {
  g,
  mg,
  mcg,
}

class DosingModel {
  final String name;
  final String? description;
  final List<ApplicationModel> applications;
  final int drugAmount;
  final DrugUnit unit;
  final String drugName;

  const DosingModel({
    this.unit = DrugUnit.mg,
    required this.drugAmount,
    required this.name,
    this.description,
    required this.applications,
    required this.drugName,
  });
}

class ApplicationModel {
  final int? dilutingSolutionVolume;

  final Drug drug;

  final double infusionRateValue;
  final String infusionRateUnit;

  final double? minInfisionRate;
  final double? maxInfisionRate;
  final double? divisions;

  final ApplicationType applicationType;

  const ApplicationModel({
    this.dilutingSolutionVolume,
    required this.drug,
    required this.infusionRateValue,
    required this.infusionRateUnit,
    this.minInfisionRate,
    this.maxInfisionRate,
    this.divisions,
    required this.applicationType,
  })  : assert(
          applicationType == ApplicationType.bolus
              ? dilutingSolutionVolume != null
              : true,
        ),
        assert(
          minInfisionRate == null || infusionRateValue >= minInfisionRate,
          'Infusion rate value $infusionRateValue is less than minimum infusion rate $minInfisionRate',
        ),
        assert(
          maxInfisionRate == null || infusionRateValue <= maxInfisionRate,
          'Infusion rate value $infusionRateValue is greater than maximum infusion rate $maxInfisionRate',
        );

  double dose(
      {required weight, required double infusion, int dilutionVolume = 100}) {
    if (infusionRateUnit == 'mcg/kg/min') {
      return (infusion * weight * 60 * dilutionVolume) / drug.amount / 1000;
    } else if (infusionRateUnit == 'mg/h') {
      return 0;
    }

    return 0;
  }
}

const pantoDose = DosingModel(
  name: 'Pantoprazole Dose in UGIB',
  drugName: 'Pantoprazole',
  drugAmount: 40,
  applications: [
    ApplicationModel(
      drug: Drug(
        name: 'Pantoprazole',
        amount: 40,
        unit: 'mg',
      ),
      infusionRateValue: 8,
      infusionRateUnit: 'mg/h',
      applicationType: ApplicationType.infusion,
    ),
  ],
);

const dobutamineInfusion = DosingModel(
  name: 'Dobutamine Dose in Cardiogenic Shock',
  drugName: 'Dobutamine',
  drugAmount: 250,
  applications: [
    ApplicationModel(
      drug: Drug(
        name: 'Dobutamine',
        amount: 250,
        unit: 'mg',
        volume: 20,
      ),
      infusionRateValue: 5,
      infusionRateUnit: 'mcg/kg/min',
      minInfisionRate: 2,
      maxInfisionRate: 20,
      divisions: 6,
      applicationType: ApplicationType.infusion,
    ),
  ],
);

class Drug {
  final String name;
  final int amount;
  final String unit;
  final int? volume;

  const Drug({
    required this.name,
    required this.amount,
    required this.unit,
    this.volume,
  });
}
