import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/expense_model.dart';
import '../models/Expenses.dart' as AmplifyExpenses;

class ExpenseService {
  /// Fetch all expenses
  static Future<List<ExpenseModel>> getExpenses() async {
    try {
      final request = ModelQueries.list(AmplifyExpenses.Expenses.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final expenses = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          final json = jsonDecode(e.data!);
          return ExpenseModel.fromJson(json);
        } else {
          // Fallback if data is null but other fields exist
          return ExpenseModel(
            id: e.id,
            title: e.title ?? 'Untitled',
            amount: double.tryParse(e.amount ?? '0') ?? 0.0,
            category: e.category ?? 'Uncategorized',
            date: e.date != null ? DateTime.parse(e.date!) : DateTime.now(),
            description: e.description ?? '',
            status: ExpenseStatus.pending,
            submittedBy: '',
            type: TransactionType.expense,
          );
        }
      }).toList();
      
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  /// Add a new expense
  static Future<void> addExpense(ExpenseModel expense) async {
    try {
      final amplifyExpense = AmplifyExpenses.Expenses(
        title: expense.title,
        amount: expense.amount.toString(),
        category: expense.category,
        date: expense.date.toIso8601String(),
        description: expense.description,
        data: jsonEncode(expense.toJson()),
      );
      final request = ModelMutations.create(amplifyExpense);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error adding expense: $e');
    }
  }
  
  /// Update expense status (e.g. for approvals)
  static Future<void> updateExpenseStatus(String id, ExpenseStatus status) async {
    try {
      final all = await getExpenses();
      final expense = all.firstWhere((e) => e.id == id);
      final updatedExpense = expense.copyWith(status: status);
      
      final amplifyExpense = AmplifyExpenses.Expenses(
        id: id,
        data: jsonEncode(updatedExpense.toJson()),
      );
      final request = ModelMutations.update(amplifyExpense);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error updating expense status: $e');
    }
  }
}
