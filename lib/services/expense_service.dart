import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ExpenseService {

  //Development URLs
  //final baseUrl = "http://192.168.25.162:9090/api";
  //static const String baseUrl = 'http://localhost:8080/api';

  //production URL
  static const String baseUrl = 'https://personal-finance-app.up.railway.app/api';

  // Get all expenses for a user
  Future<List<Expense>> getAllExpenses(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/expenses?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load expenses');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get expenses by category
  Future<List<Expense>> getExpensesByCategory(int userId, String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/expenses/category/$category?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load expenses by category');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create new expense
  Future<Expense> createExpense(int userId, double amount, String category, DateTime date, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expenses?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'category': category,
          'date': date.toIso8601String().split('T')[0],
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        return Expense.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create expense');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update expense
  Future<Expense> updateExpense(int expenseId, int userId, double amount, String category, DateTime date, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/expenses/$expenseId?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'category': category,
          'date': date.toIso8601String().split('T')[0],
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return Expense.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update expense');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete expense
  Future<bool> deleteExpense(int expenseId, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/expenses/$expenseId?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get analytics by category
  Future<Map<String, double>> getExpensesByCategoryAnalytics(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/expenses/analytics/by-category?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return jsonMap.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } else {
        throw Exception('Failed to load analytics');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get total expenses
  Future<double> getTotalExpenses(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/expenses/analytics/total?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return (jsonMap['total'] as num).toDouble();
      } else {
        throw Exception('Failed to load total expenses');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 