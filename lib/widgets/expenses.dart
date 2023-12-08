import 'package:first_app/widgets/chart/chart.dart';
import 'package:first_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:first_app/models/expense.dart';
import 'package:first_app/widgets/expenses_list/expenses_list.dart';
import 'package:first_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
final List<Expense> _registeredExpenses = [

];

 void _openAddExpenseOverlay(){
  showModalBottomSheet(context: context, builder:(ctx) => NewExpense(onAddExpense: _addExpense),
  );

}

 void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
 }

void _removeExpense(Expense expense){
  final expenseIndex = _registeredExpenses.indexOf(expense);
  setState(() {
    _registeredExpenses.remove(expense);
  });
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      content: const Text('Expense deleted'),
      action: SnackBarAction(label: 'Undo', onPressed: (){
        setState(() {
          _registeredExpenses.insert(expenseIndex, expense);
        });
      }),
      ),
      );
}

  @override
  Widget build(BuildContext context) {

    Widget mainContent = const Center(
      child: Text('No expenses found') ,
      );

    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
            expenses: _registeredExpenses,
            onRemoveExpense: _removeExpense,
            );
    }

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
      ],),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
