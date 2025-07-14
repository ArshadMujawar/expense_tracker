import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/budget_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  
  List<Budget> _budgets = [];
  Budget? _currentBudget;
  Budget? _budgetOverview;
  bool _isLoading = false;
  String? _error;

  List<Budget> get budgets => _budgets;
  Budget? get currentBudget => _currentBudget;
  Budget? get budgetOverview => _budgetOverview;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all budgets for a user
  Future<void> loadBudgets(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgets = await _budgetService.getAllBudgets(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load current month budget
  Future<void> loadCurrentMonthBudget(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentBudget = await _budgetService.getCurrentMonthBudget(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load budget overview
  Future<void> loadBudgetOverview(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgetOverview = await _budgetService.getBudgetOverview(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new budget
  Future<bool> createBudget(int userId, String month, double amount) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newBudget = await _budgetService.createBudget(userId, month, amount);
      _budgets.insert(0, newBudget); // Add to beginning of list
      
      // Update current budget if it's the current month
      if (month == _getCurrentMonth()) {
        _currentBudget = newBudget;
      }
      
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

  // Update budget
  Future<bool> updateBudget(int budgetId, int userId, String month, double amount) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBudget = await _budgetService.updateBudget(budgetId, userId, month, amount);
      
      // Update in budgets list
      final index = _budgets.indexWhere((budget) => budget.id == budgetId);
      if (index != -1) {
        _budgets[index] = updatedBudget;
      }
      
      // Update current budget if it's the current month
      if (month == _getCurrentMonth()) {
        _currentBudget = updatedBudget;
      }
      
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

  // Delete budget
  Future<bool> deleteBudget(int budgetId, int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _budgetService.deleteBudget(budgetId, userId);
      if (success) {
        _budgets.removeWhere((budget) => budget.id == budgetId);
        
        // Clear current budget if it was deleted
        if (_currentBudget?.id == budgetId) {
          _currentBudget = null;
        }
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

  // Get budget by month
  Budget? getBudgetByMonth(String month) {
    try {
      return _budgets.firstWhere((budget) => budget.month == month);
    } catch (e) {
      return null;
    }
  }

  // Check if budget exists for month
  bool hasBudgetForMonth(String month) {
    return _budgets.any((budget) => budget.month == month);
  }

  // Get current month string (YYYY-MM format)
  String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // Get month name from YYYY-MM format
  String getMonthName(String month) {
    final parts = month.split('-');
    if (parts.length == 2) {
      final year = int.parse(parts[0]);
      final monthNum = int.parse(parts[1]);
      final date = DateTime(year, monthNum);
      return '${_getMonthName(monthNum)} $year';
    }
    return month;
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return 'Unknown';
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh all budget data
  Future<void> refreshAll(int userId) async {
    await Future.wait([
      loadBudgets(userId),
      loadCurrentMonthBudget(userId),
      loadBudgetOverview(userId),
    ]);
  }
} 