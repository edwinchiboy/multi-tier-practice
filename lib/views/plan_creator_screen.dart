import 'package:flutter/material.dart';
import 'package:untitled/views/plan_screen.dart';
import 'package:untitled/models/plan.dart';
import 'package:untitled/plan_provider.dart';

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plans')),
      body: Column(children: <Widget>[
        _buildListCreator(),
        Expanded(child: _buildMasterPlans())
      ]),
    );
  }

  Widget _buildListCreator() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          color: Theme.of(context).cardColor,
          elevation: 10,
          child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                  labelText: 'Add a plan', contentPadding: EdgeInsets.all(20)),
              onEditingComplete: addPlan),
        ));
  }

  void addPlan() {
    final text = textController.text;
    final controller = PlanProvider.of(context);
    controller?.addNewPlan(text);

    textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  Widget _buildMasterPlans() {
    final plans = PlanProvider.of(context)?.plans;
    if (plans?.isEmpty ?? true) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.note, size: 100, color: Colors.grey),
            Text('You do not have any plans yet.',
                style: Theme.of(context).textTheme.headline5)
          ]);
    }
    return ListView.builder(
        itemCount: plans?.length,
        itemBuilder: (context, index) {
          final plan = plans?[index];
          return Dismissible(
            key: ValueKey(plan),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final controller = PlanProvider.of(context);
              controller?.deletePlan(plan ?? Plan(id: 0));
              setState(() {});
            },
            child: ListTile(
                title: Text(plan?.name ?? ""),
                subtitle: Text(plan?.completenessMessage ?? ""),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PlanScreen(plan: plan)));
                }),
          );
        });
  }
}
