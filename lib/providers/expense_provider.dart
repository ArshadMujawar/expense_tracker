import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  
  List<Expense> _expenses = [];
  Map<String, double> _categoryAnalytics = {};
  double _totalExpenses = 0.0;
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  Map<String, double> get categoryAnalytics => _categoryAnalytics;
  double get totalExpenses => _totalExpenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all expenses for a user
  Future<void> loadExpenses(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _expenseService.getAllExpenses(userId);
      await _loadAnalytics(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load expenses by category
  Future<void> loadExpensesByCategory(int userId, String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _expenseService.getExpensesByCategory(userId, category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new expense
  Future<bool> createExpense(int userId, double amount, String category, DateTime date, String description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newExpense = await _expenseService.createExpense(userId, amount, category, date, description);
      _expenses.insert(0, newExpense); // Add to beginning of list
      await _loadAnalytics(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update expense
  Future<bool> updateExpense(int expenseId, int userId, double amount, String category, DateTime date, String description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedExpense = await _expenseService.updateExpense(expenseId, userId, amount, category, date, description);
      final index = _expenses.indexWhere((expense) => expense.id == expenseId);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
      await _loadAnalytics(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete expense
  Future<bool> deleteExpense(int expenseId, int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _expenseService.deleteExpense(expenseId, userId);
      if (success) {
        _expenses.removeWhere((expense) => expense.id == expenseId);
        await _loadAnalytics(userId);
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load analytics
  Future<void> _loadAnalytics(int userId) async {
    try {
      _categoryAnalytics = await _expenseService.getExpensesByCategoryAnalytics(userId);
      _totalExpenses = await _expenseService.getTotalExpenses(userId);
    } catch (e) {
      // Analytics loading failed, but don't show error to user
      _categoryAnalytics = {};
      _totalExpenses = 0.0;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get expenses for a specific month
  List<Expense> getExpensesForMonth(int year, int month) {
    return _expenses.where((expense) {
      return expense.date.year == year && expense.date.month == month;
    }).toList();
  }

  // Get expenses for today
  List<Expense> getExpensesForToday() {
    final today = DateTime.now();
    return _expenses.where((expense) {
      return expense.date.year == today.year &&
             expense.date.month == today.month &&
             expense.date.day == today.day;
    }).toList();
  }

  // Get total for a specific month
  double getTotalForMonth(int year, int month) {
    return getExpensesForMonth(year, month)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }
} 