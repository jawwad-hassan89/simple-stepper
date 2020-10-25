import 'package:flutter/material.dart';
import 'package:simple_stepper/simple_stepper.dart';

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SimpleStepperExample(),
        ),
      ),
    ),
  );
}

class SimpleStepperExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SimpleStepperExampleState();
}

class _SimpleStepperExampleState extends State<SimpleStepperExample> {
  StepController controller;

  final List<SimpleStep> steps = [
    SimpleStep(Icons.directions_walk, label: 'Walk'),
    SimpleStep(Icons.directions_bike, label: 'Bike'),
    SimpleStep(Icons.directions_bus, label: 'Take Bus'),
    SimpleStep(Icons.directions_boat, label: 'Take Boat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 48)),
        SimpleStepper(
          steps: steps,
          controller: controller,
        ),
        Padding(padding: EdgeInsets.only(top: 16)),
        RaisedButton(
          onPressed: () => controller.nextStep(),
          child: Text('Next Step'),
        ),
        Padding(padding: EdgeInsets.only(top: 16)),
        RaisedButton(
          onPressed: () => controller.reset(),
          child: Text('Reset'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller = StepController(maxSteps: steps.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
