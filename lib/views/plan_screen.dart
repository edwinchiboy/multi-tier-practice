import 'package:flutter/material.dart';
import 'package:untitled/plan_provider.dart';

import 'package:untitled/models/plan.dart';
import 'package:untitled/models/task.dart';

class PlanScreen extends StatefulWidget {
  final Plan? plan;

  const PlanScreen({Key? key, this.plan}) : super(key: key);

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ScrollController scrollController = ScrollController();

  Plan get plan => widget.plan ?? Plan();

  @override
  void initState() {
    super.initState();

    scrollController
      .addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final controller = PlanProvider.of(context);
        controller?.savePlan(plan);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Master Plan')),
        body: Column(
          children: [
            Expanded(child: _buildList()),
            SafeArea(child: Text(plan.completenessMessage))
          ],
        ),
        floatingActionButton: _buildAddTaskButton(context),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks?.length,
      itemBuilder: (context, index) => _buildTaskTile(plan.tasks?[index]??Task()),
    );
  }

  Widget _buildTaskTile(Task task) {
    return Dismissible(
      key: ValueKey(task),
      background: Container(
        color: Colors.red,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        final controller = PlanProvider.of(context);
        controller?.deleteTask(plan, task);
        setState(() {});
      },
      child: ListTile(
          leading: Checkbox(
              value: task.complete,
              onChanged: (selected) {
                setState(() {
                  task.complete = selected ?? true;
                });
              }),
          title: TextFormField(
              initialValue: task.description,
              onFieldSubmitted: (text) {
                setState(() {
                  task.description = text;
                });
              })),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        final controller = PlanProvider.of(context);
        controller?.createNewTask(plan);
        setState(() {});
      },
    );
  }
}
