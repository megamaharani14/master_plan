import '../models/data_layer.dart';
import 'package:flutter/material.dart';
import '../provider/plan_provider.dart';


class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  @override
  void initState() { 
    super.initState();
    scrollController = ScrollController()
     ..addListener(() { 
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
    return Scaffold(
      // Replace 'Namaku' with your nickname
      appBar: AppBar(title: const Text('Master Plan'),
      foregroundColor: Colors.white,
      backgroundColor: Colors.purple,),
      body: ValueListenableBuilder<Plan>(
       valueListenable: PlanProvider.of(context),
       builder: (context, plan, child) {
         return Column(
           children: [
             Expanded(child: _buildList(plan)),
             SafeArea(child: Text(plan.completenessMessage))
           ],
         );
       },
     ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<Plan> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
      onPressed: () {
       Plan currentPlan = planNotifier.value;
        planNotifier.value = Plan(
        name: currentPlan.name,
        tasks: List<Task>.from(currentPlan.tasks)..add(const Task()),
          );
        },
    );
  }
  

    Widget _buildList(Plan plan) { 
      return ListView.builder(
        controller: scrollController,
      keyboardDismissBehavior: Theme.of(context).platform == 
      TargetPlatform.iOS
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,

        itemCount: plan.tasks.length, 
        itemBuilder: (context, index) =>
        _buildTaskTile(plan.tasks[index], index, context),
    );
}

    Widget _buildTaskTile(Task task, int index, BuildContext context) {
       ValueNotifier<Plan> planNotifier = PlanProvider.of(context); 
       return ListTile(
        leading: Checkbox( value: task.complete,
        onChanged: (selected) {
        Plan currentPlan = planNotifier.value; planNotifier.value = Plan(
        name: currentPlan.name,
        tasks: List<Task>.from(currentPlan.tasks)
        ..[index] = Task(
        description: task.description, complete: selected ?? false,
       ),
   );
  }),
      title: TextFormField( 
        initialValue: task.description,
        onChanged: (text) {
          Plan currentPlan = planNotifier.value; 
          planNotifier.value = Plan(
          name: currentPlan.name,
            tasks: List<Task>.from(currentPlan.tasks)
            ..[index] = Task( 
             description: text,
             complete: task.complete,
            ),
          );
       },
     ),
    );
  }
}