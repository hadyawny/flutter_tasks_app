import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedCounter extends StatefulWidget {
  final int completed;
  final int overdue;
  final int toDo;
  final int inProgress;

  AnimatedCounter({
    required this.completed,
    required this.overdue,
    required this.toDo,
    required this.inProgress,
  });

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  int displayedCompleted = 0;
  int displayedOverdue = 0;
  int displayedToDo = 0;
  int displayedInProgress = 0;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (displayedCompleted < widget.completed) {
        setState(() {
          displayedCompleted++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const  Duration(milliseconds: 200), (timer) {
      if (displayedOverdue < widget.overdue) {
        setState(() {
          displayedOverdue++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const  Duration(milliseconds: 200), (timer) {
      if (displayedToDo < widget.toDo) {
        setState(() {
          displayedToDo++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const  Duration(milliseconds: 200), (timer) {
      if (displayedInProgress < widget.inProgress) {
        setState(() {
          displayedInProgress++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'To Do Tasks: $displayedToDo',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'In Progress Tasks: $displayedInProgress',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Completed Tasks: $displayedCompleted',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Overdue Tasks: $displayedOverdue',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
