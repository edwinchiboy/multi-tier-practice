import 'package:flutter/material.dart';
import 'package:untitled/plan_provider.dart';
import 'package:untitled/views/plan_creator_screen.dart';

void main() => runApp(const MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlanProvider(
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const PlanCreatorScreen(),
      ),
    );
  }
}
