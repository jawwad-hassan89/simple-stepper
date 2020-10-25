library simple_stepper;

import 'dart:async';
import 'package:flutter/material.dart';

enum SimpleStepState { pending, ongoing, complete }

class SimpleStep {
  final String label;
  final IconData icon;

  SimpleStep(this.icon, {this.label})
      : assert(label != null ? label.length < 12 : true);
}

class SimpleStepper extends StatelessWidget {
  final List<SimpleStep> steps;
  final StepController controller;
  final Color activeColor;
  final Color inactiveColor;

  SimpleStepper({
    Key key,
    @required this.steps,
    @required this.controller,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.black38,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 46,
        child: LimitedBox(
          maxHeight: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: steps.length,
            itemBuilder: (context, index) => StreamBuilder<int>(
                  initialData: controller.currentStep,
                  stream: controller.stepStream,
                  builder: (context, snapshot) => _SimpleStepItem(
                        icon: steps[index].icon,
                        label: steps[index].label,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        state: _getStepState(index, snapshot.data),
                        showLeadingBar: index != 0,
                        showTrailingBar: index != steps.length - 1,
                      ),
                ),
          ),
        ),
      ),
    );
  }

  _getStepState(int index, int currentStep) {
    if (index < currentStep) return SimpleStepState.complete;
    if (index == currentStep) return SimpleStepState.ongoing;
    return SimpleStepState.pending;
  }
}

class StepController {
  final int maxSteps;
  int _currentStep = 0;
  
  StepController({@required this.maxSteps, initialStep = 0})
      : assert(initialStep >= 0 && initialStep < maxSteps),
        _currentStep = initialStep;

  final StreamController<int> _currentStepController =
      StreamController<int>.broadcast();

  int get currentStep => _currentStep;
  Stream<int> get stepStream => _currentStepController.stream;

  nextStep() {
    if (_currentStep < maxSteps) {
      _currentStep++;
      _currentStepController.sink.add(_currentStep);
    }
  }

  toStepIndex(int index) {
    assert(index >= 0 && index < maxSteps);
    _currentStep = index;
    _currentStepController.sink.add(_currentStep);
  }

  reset() {
    toStepIndex(0);
  }

  void dispose() {
    _currentStepController.close();
  }
}

class _SimpleStepItem extends StatelessWidget {
  final SimpleStepState state;
  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final bool showTrailingBar;
  final bool showLeadingBar;
  final double size;
  final double spacing;

  final double _iconMargins = 8;

  const _SimpleStepItem({
    Key key,
    @required this.icon,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.black38,
    this.label,
    this.state = SimpleStepState.pending,
    this.showTrailingBar = false,
    this.showLeadingBar = false,
    this.size = 24,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildConnectingBar(showLeadingBar),
            _buildIconWidget(),
            _buildConnectingBar(showTrailingBar),
          ],
        ),
        _buildLabelWidget(),
      ],
    );
  }

  _buildConnectingBar(bool filled) {
    return Container(
      height: 1,
      width: spacing,
      color: filled ? inactiveColor : Colors.transparent,
    );
  }

  _buildIconWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _iconMargins),
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getBgColor(),
        shape: BoxShape.circle,
        border: state == SimpleStepState.ongoing
            ? Border.all(color: activeColor, width: 2)
            : null,
      ),
      child: Icon(
        state == SimpleStepState.complete ? Icons.check : icon,
        color: state == SimpleStepState.ongoing ? activeColor : Colors.white,
        size: size * 0.6,
      ),
    );
  }

  _buildLabelWidget() {
    if (label == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        label,
        style: state == SimpleStepState.complete
            ? TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12)
            : TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.normal,
                fontSize: 12),
      ),
    );
  }

  _getBgColor() {
    if (state == SimpleStepState.ongoing) return Colors.white;
    if (state == SimpleStepState.complete) return activeColor;
    return inactiveColor;
  }
}
