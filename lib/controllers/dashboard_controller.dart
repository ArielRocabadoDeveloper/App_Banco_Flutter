import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';

class DashboardController extends ChangeNotifier {
  DashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;
  int _selectedIndex = 0;
  String _searchQuery = '';
  TransactionType? _selectedTransactionType;
  DateTime? _selectedDate;

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedIndex => _selectedIndex;
  String get searchQuery => _searchQuery;
  TransactionType? get selectedTransactionType => _selectedTransactionType;
  DateTime? get selectedDate => _selectedDate;

  // Cambiar índice seleccionado en la barra de navegación
  void setSelectedIndex(int index) {
    if (index >= 0 && index <= 3) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Actualizar búsqueda
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Filtrar por tipo de transacción
  void setSelectedTransactionType(TransactionType? type) {
    _selectedTransactionType = type;
    notifyListeners();
  }

  // Filtrar por fecha
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Obtener transacciones filtradas
  List<Transaction> getFilteredTransactions() {
    if (_dashboardData == null) return [];

    return _dashboardData!.transactions.where((transaction) {
      bool matchesSearch = transaction.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesType = _selectedTransactionType == null || transaction.type == _selectedTransactionType;
      bool matchesDate = _selectedDate == null || 
          transaction.date.year == _selectedDate!.year &&
          transaction.date.month == _selectedDate!.month &&
          transaction.date.day == _selectedDate!.day;

      return matchesSearch && matchesType && matchesDate;
    }).toList();
  }

  // Obtener estadísticas
  Map<String, double> getStatistics() {
    if (_dashboardData == null) return {};

    final now = DateTime.now();
    final thisMonth = now.month;
    final thisYear = now.year;

    double monthlyIncome = 0;
    double monthlyExpenses = 0;
    double weeklyIncome = 0;
    double weeklyExpenses = 0;

    for (var transaction in _dashboardData!.transactions) {
      if (transaction.date.month == thisMonth && transaction.date.year == thisYear) {
        if (transaction.type == TransactionType.income) {
          monthlyIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          monthlyExpenses += transaction.amount.abs();
        }
      }

      // Calcular gastos semanales (últimos 7 días)
      if (transaction.date.isAfter(now.subtract(const Duration(days: 7)))) {
        if (transaction.type == TransactionType.income) {
          weeklyIncome += transaction.amount;
        } else if (transaction.type == TransactionType.expense) {
          weeklyExpenses += transaction.amount.abs();
        }
      }
    }

    return {
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'weeklyIncome': weeklyIncome,
      'weeklyExpenses': weeklyExpenses,
      'savingsRate': monthlyIncome > 0 ? ((monthlyIncome - monthlyExpenses) / monthlyIncome) * 100 : 0,
    };
  }

  // Validar límites de transacción
  bool validateTransactionLimits(Transaction transaction) {
    if (_dashboardData == null) return false;

    // Límite diario de gastos
    const double dailyExpenseLimit = 1000.0;
    final today = DateTime.now();
    final todayExpenses = _dashboardData!.transactions
        .where((t) => 
            t.type == TransactionType.expense &&
            t.date.year == today.year &&
            t.date.month == today.month &&
            t.date.day == today.day)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    if (transaction.type == TransactionType.expense &&
        todayExpenses + transaction.amount.abs() > dailyExpenseLimit) {
      throw Exception('Has excedido el límite diario de gastos');
    }

    // Límite de transacción individual
    const double singleTransactionLimit = 500.0;
    if (transaction.amount.abs() > singleTransactionLimit) {
      throw Exception('La transacción excede el límite permitido');
    }

    return true;
  }

  // Validar frecuencia de transacciones
  bool validateTransactionFrequency(Transaction transaction) {
    if (_dashboardData == null) return false;

    final now = DateTime.now();
    final lastHour = now.subtract(const Duration(hours: 1));
    
    // Contar transacciones en la última hora
    final recentTransactions = _dashboardData!.transactions
        .where((t) => t.date.isAfter(lastHour))
        .length;

    if (recentTransactions >= 10) {
      throw Exception('Demasiadas transacciones en poco tiempo');
    }

    return true;
  }

  // Validar patrones sospechosos
  bool validateSuspiciousPatterns(Transaction transaction) {
    if (_dashboardData == null) return false;

    // Verificar transacciones repetidas
    final similarTransactions = _dashboardData!.transactions
        .where((t) => 
            t.amount == transaction.amount &&
            t.type == transaction.type &&
            t.date.isAfter(DateTime.now().subtract(const Duration(minutes: 5))))
        .length;

    if (similarTransactions >= 3) {
      throw Exception('Patrón de transacciones sospechoso detectado');
    }

    return true;
  }

  // Validar datos del dashboard
  bool _validateDashboardData() {
    if (_dashboardData == null) return false;

    // Validar balance y transacciones
    if (!_dashboardData!.isValidBalance()) {
      print('Balance inválido');
      return false;
    }

    // Validar transacciones
    for (var transaction in _dashboardData!.transactions) {
      if (!transaction.isValidAmount()) {
        print('Monto de transacción inválido');
        return false;
      }
      if (!transaction.isValidDate()) {
        print('Fecha de transacción inválida');
        return false;
      }
      if (!transaction.isValidTitle()) {
        print('Título de transacción inválido');
        return false;
      }
    }

    // Validar servicios
    for (var service in _dashboardData!.services) {
      if (!service.isValidName()) {
        print('Nombre de servicio inválido');
        return false;
      }
    }

    // Validar acciones rápidas
    for (var action in _dashboardData!.quickActions) {
      if (!action.isValidName()) {
        print('Nombre de acción rápida inválido');
        return false;
      }
    }

    return true;
  }

  // Cargar datos del dashboard
  Future<void> loadDashboardData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      // Datos de ejemplo
      _dashboardData = DashboardData(
        balance: 25000.00,
        income: 3500.00,
        expenses: 1200.00,
        transactions: [
          Transaction(
            id: '1',
            title: 'Recibido',
            amount: 3500.00,
            date: DateTime.now().subtract(const Duration(hours: 2)),
            type: TransactionType.income,
            status: TransactionStatus.completed,
            description: 'Ingreso mensual',
          ),
          Transaction(
            id: '2',
            title: 'Pago de Servicios',
            amount: -1200.00,
            date: DateTime.now().subtract(const Duration(hours: 5)),
            type: TransactionType.expense,
            status: TransactionStatus.completed,
            description: 'Pago de servicios básicos',
          ),
        ],
        services: [
          Service(
            id: '1',
            name: 'Pagos de Servicios',
            icon: Icons.payment,
            isEnabled: true,
            description: 'Paga tus servicios básicos',
          ),
          Service(
            id: '2',
            name: 'Transferencias',
            icon: Icons.swap_horiz,
            isEnabled: true,
            description: 'Envía dinero a otros usuarios',
          ),
          Service(
            id: '3',
            name: 'Inversiones',
            icon: Icons.trending_up,
            isEnabled: false,
            description: 'Invierte tu dinero',
          ),
          Service(
            id: '4',
            name: 'Seguros',
            icon: Icons.security,
            isEnabled: true,
            description: 'Contrata seguros',
          ),
        ],
        quickActions: [
          QuickAction(
            id: '1',
            name: 'Enviar',
            icon: Icons.send,
            isEnabled: true,
            description: 'Enviar dinero',
          ),
          QuickAction(
            id: '2',
            name: 'Recibir',
            icon: Icons.qr_code,
            isEnabled: true,
            description: 'Recibir dinero',
          ),
          QuickAction(
            id: '3',
            name: 'Pagar',
            icon: Icons.payment,
            isEnabled: true,
            description: 'Pagar servicios',
          ),
          QuickAction(
            id: '4',
            name: 'Recargar',
            icon: Icons.phone_android,
            isEnabled: true,
            description: 'Recargar celular',
          ),
        ],
      );

      // Validar datos
      if (!_validateDashboardData()) {
        print('Error en la validación de datos del dashboard');
        throw Exception('Datos del dashboard inválidos');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error al cargar datos del dashboard: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar balance
  Future<void> updateBalance(double newBalance) async {
    if (_dashboardData == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));

      // Validar que el nuevo balance sea válido
      if (newBalance < 0) {
        throw Exception('El balance no puede ser negativo');
      }

      _dashboardData = DashboardData(
        balance: newBalance,
        income: _dashboardData!.income,
        expenses: _dashboardData!.expenses,
        transactions: _dashboardData!.transactions,
        services: _dashboardData!.services,
        quickActions: _dashboardData!.quickActions,
      );

      if (!_validateDashboardData()) {
        throw Exception('Nuevo balance inválido');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nueva transacción con validaciones adicionales
  Future<void> addTransaction(Transaction transaction) async {
    if (_dashboardData == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));

      // Validaciones básicas
      if (!transaction.isValidAmount() ||
          !transaction.isValidDate() ||
          !transaction.isValidTitle()) {
        throw Exception('Transacción inválida');
      }

      // Validaciones adicionales
      if (!validateTransactionLimits(transaction)) {
        throw Exception('La transacción excede los límites permitidos');
      }

      if (!validateTransactionFrequency(transaction)) {
        throw Exception('Demasiadas transacciones en poco tiempo');
      }

      if (!validateSuspiciousPatterns(transaction)) {
        throw Exception('Patrón de transacciones sospechoso');
      }

      // Validar que el balance no se vuelva negativo
      double newBalance = _dashboardData!.balance;
      if (transaction.type == TransactionType.income) {
        newBalance += transaction.amount;
      } else if (transaction.type == TransactionType.expense) {
        newBalance += transaction.amount; // Ya es negativo
        if (newBalance < 0) {
          throw Exception('Saldo insuficiente para realizar la transacción');
        }
      }

      _dashboardData = DashboardData(
        balance: newBalance,
        income: transaction.type == TransactionType.income
            ? _dashboardData!.income + transaction.amount
            : _dashboardData!.income,
        expenses: transaction.type == TransactionType.expense
            ? _dashboardData!.expenses + transaction.amount.abs()
            : _dashboardData!.expenses,
        transactions: [..._dashboardData!.transactions, transaction],
        services: _dashboardData!.services,
        quickActions: _dashboardData!.quickActions,
      );

      if (!_validateDashboardData()) {
        throw Exception('Error al actualizar el balance');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filtrar transacciones por tipo
  List<Transaction> getTransactionsByType(TransactionType type) {
    if (_dashboardData == null) return [];
    return _dashboardData!.transactions.where((t) => t.type == type).toList();
  }

  // Obtener transacciones pendientes
  List<Transaction> getPendingTransactions() {
    if (_dashboardData == null) return [];
    return _dashboardData!.transactions
        .where((t) => t.status == TransactionStatus.pending)
        .toList();
  }

  // Obtener servicios habilitados
  List<Service> getEnabledServices() {
    if (_dashboardData == null) return [];
    return _dashboardData!.services.where((s) => s.isEnabled).toList();
  }

  // Obtener acciones rápidas habilitadas
  List<QuickAction> getEnabledQuickActions() {
    if (_dashboardData == null) return [];
    return _dashboardData!.quickActions.where((a) => a.isEnabled).toList();
  }

  // Calcular total de ingresos del mes
  double getMonthlyIncome() {
    if (_dashboardData == null) return 0;
    final now = DateTime.now();
    return _dashboardData!.transactions
        .where((t) => 
            t.type == TransactionType.income &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // Calcular total de gastos del mes
  double getMonthlyExpenses() {
    if (_dashboardData == null) return 0;
    final now = DateTime.now();
    return _dashboardData!.transactions
        .where((t) => 
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0, (sum, t) => sum + t.amount.abs());
  }
} 