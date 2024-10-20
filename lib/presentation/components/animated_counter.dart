import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

// AnimatedCounter StatefulWidget to display counts with animation
class AnimatedCounter extends StatefulWidget {
  final int completed;
  final int overdue;
  final int toDo;
  final int inProgress;

  const AnimatedCounter({
    super.key,
    required this.completed,
    required this.overdue,
    required this.toDo,
    required this.inProgress,
  });

  @override
  // ignore: library_private_types_in_public_api
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

  // Function to animate the counts

  void startAnimation() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (displayedCompleted < widget.completed) {
        setState(() {
          displayedCompleted++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (displayedOverdue < widget.overdue) {
        setState(() {
          displayedOverdue++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (displayedToDo < widget.toDo) {
        setState(() {
          displayedToDo++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
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
          style: GoogleFonts.dmSerifText(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'In Progress Tasks: $displayedInProgress',
          style: GoogleFonts.dmSerifText(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Completed Tasks: $displayedCompleted',
          style: GoogleFonts.dmSerifText(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Overdue Tasks: $displayedOverdue',
          style: GoogleFonts.dmSerifText(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
