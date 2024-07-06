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

  const DosingModel({
    required this.name,
    this.description,
    required this.applications,
  });
}

class ApplicationModel {
  final int? dilutingSolutionVolume;

  final Drug drug;

  final double infusionRateValue;
  final String infusionRateUnit;

  final double minInfisionRate;
  final double maxInfisionRate;
  final double interval;
  final List<String> infusionTips;

  final String solutionType;

  final ApplicationType applicationType;

  const ApplicationModel({
    this.solutionType = 'NaCl 0.9%',
    this.dilutingSolutionVolume,
    this.infusionTips = const [],
    required this.drug,
    required this.infusionRateValue,
    required this.infusionRateUnit,
    required this.minInfisionRate,
    required this.maxInfisionRate,
    required this.interval,
    required this.applicationType,
  })  : assert(
          applicationType == ApplicationType.bolus
              ? dilutingSolutionVolume != null
              : true,
        ),
        assert(
          infusionRateValue >= minInfisionRate,
          'Infusion rate value $infusionRateValue is less than minimum infusion rate $minInfisionRate',
        ),
        assert(
          infusionRateValue <= maxInfisionRate,
          'Infusion rate value $infusionRateValue is greater than maximum infusion rate $maxInfisionRate',
        );

  double dose(
      {required weight, required double infusion, int dilutionVolume = 100}) {
    if (infusionRateUnit == 'mcg/kg/min') {
      return (infusion * weight * 60 * dilutionVolume) / drug.amount / 1000;
    } else if (infusionRateUnit == 'mg/h') {
      return (infusion * dilutionVolume) / drug.amount;
    }

    return 0;
  }

  bool tooMuchInterval() {
    return (maxInfisionRate - minInfisionRate) / interval > 10 ? true : false;
  }
}

class Drug {
  final String name;
  final int amount;
  final String unit;
  final int? volume;
  final String? tradeName;

  const Drug({
    required this.name,
    required this.amount,
    required this.unit,
    this.volume,
    this.tradeName,
  });

  @override
  String toString() {
    return '$name $amount $unit / $volume ml';
  }

  String fullName() {
    return '$name ${tradeName == null ? '' : '($tradeName)'} $amount $unit / ${volume ?? ''} ml';
  }
}

const List<DosingModel> allInfusions = [
  dobutamineInfusion,
  nicardipineInfusion,
  dopamineInfusion
];

const dobutamineInfusion = DosingModel(
  name: 'Dobutamin infüzyonu',
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
      interval: 3,
      applicationType: ApplicationType.infusion,
    ),
  ],
);

const nicardipineInfusion = DosingModel(
  name: 'Nicardipin uygulama',
  applications: [
    ApplicationModel(
      drug: Drug(
          name: 'Nicardipine',
          amount: 25,
          unit: 'mg',
          volume: 10,
          tradeName: 'Ninax®'),
      infusionRateValue: 5,
      infusionRateUnit: 'mg/h',
      minInfisionRate: 5,
      maxInfisionRate: 15,
      interval: 2.5,
      applicationType: ApplicationType.infusion,
      infusionTips: [
        'Etki için 15 dk bekle',
        'Hedef kan basıncına ulaşılmazsa dozu 2.5 mg/saat arttır'
      ],
    ),
  ],
);

const dopamineInfusion = DosingModel(
  name: 'Dopamin infüzyonu',
  applications: [
    ApplicationModel(
        drug: Drug(
            name: 'Dopamin',
            amount: 200,
            unit: 'mg',
            tradeName: 'Dobetal®',
            volume: 5),
        infusionRateValue: 10,
        minInfisionRate: 2.5,
        maxInfisionRate: 50,
        interval: 2.5,
        infusionRateUnit: 'mcg/kg/min',
        solutionType: '%5 Dextroz',
        applicationType: ApplicationType.infusion)
  ],
);
