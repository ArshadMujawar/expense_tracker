import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/budget.dart';

class BudgetService {

  //Development URLs
  //final baseUrl = "http://192.168.25.162:9090/api";
  //static const String baseUrl = 'http://localhost:8080/api';

  //production URL
  static const String baseUrl = 'https://personal-finance-app.up.railway.app/api';

  // Get all budgets for a user
  Future<List<Budget>> getAllBudgets(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budgets?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Budget.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load budgets');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get budget by month
  Future<Budget?> getBudgetByMonth(int userId, String month) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budgets/month/$month?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load budget');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get current month budget
  Future<Budget?> getCurrentMonthBudget(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budgets/current?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load current month budget');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get budget overview
  Future<Budget> getBudgetOverview(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/budgets/overview?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load budget overview');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create new budget
  Future<Budget> createBudget(int userId, String month, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/budgets?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'month': month,
          'amount': amount,
        }),
      );

      if (response.statusCode == 201) {
        return Budget.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create budget');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update budget
  Future<Budget> updateBudget(int budgetId, int userId, String month, double amount) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/budgets/$budgetId?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'month': month,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update budget');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete budget
  Future<bool> deleteBudget(int budgetId, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/budgets/$budgetId?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 