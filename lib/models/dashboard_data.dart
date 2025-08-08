import 'package:flutter/material.dart';

class DashboardData {
  final double balance;
  final double income;
  final double expenses;
  final List<Transaction> transactions;
  final List<Service> services;
  final List<QuickAction> quickActions;

  DashboardData({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.transactions,
    required this.services,
    required this.quickActions,
  });

  // Validar que el balance sea positivo
  bool isValidBalance() => balance >= 0;

  // Validar que los ingresos y gastos sean positivos
  bool isValidIncomeExpenses() => income >= 0 && expenses >= 0;

  // Validar que el balance coincida con ingresos - gastos
  bool isBalanceConsistent() => (income - expenses).abs() <= 0.01;
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.description,
  });

  // Validar que el monto sea válido
  bool isValidAmount() => amount != 0;

  // Validar que la fecha no sea futura
  bool isValidDate() => date.isBefore(DateTime.now());

  // Validar que el título no esté vacío
  bool isValidTitle() => title.isNotEmpty;
}

enum TransactionType {
  income,
  expense,
  transfer
}

enum TransactionStatus {
  completed,
  pending,
  failed
}

class Service {
  final String id;
  final String name;
  final IconData icon;
  final bool isEnabled;
  final String? description;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.isEnabled,
    this.description,
  });

  // Validar que el nombre no esté vacío
  bool isValidName() => name.isNotEmpty;
}

class QuickAction {
  final String id;
  final String name;
  final IconData icon;
  final bool isEnabled;
  final String? description;

  QuickAction({
    required this.id,
    required this.name,
    required this.icon,
    required this.isEnabled,
    this.description,
  });

  // Validar que el nombre no esté vacío
  bool isValidName() => name.isNotEmpty;
} 