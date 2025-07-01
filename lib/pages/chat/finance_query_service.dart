import 'package:finease/db/entries.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/db/settings.dart';

// Intent types for financial queries
enum QueryIntent {
  expenses,
  income,
  savings,
  balance,
  unknown,
}

// Time range for queries
class TimeRange {
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  TimeRange({
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  // Factory to create a time range for "last month"
  factory TimeRange.lastMonth() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final endOfLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);
    
    return TimeRange(
      startDate: lastMonth,
      endDate: endOfLastMonth,
      description: 'last month',
    );
  }

  // Factory to create a time range for "this month"
  factory TimeRange.thisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return TimeRange(
      startDate: startOfMonth,
      endDate: now,
      description: 'this month so far',
    );
  }

  // Factory for specific month by name
  factory TimeRange.specificMonth(int month, int year) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);
    
    return TimeRange(
      startDate: startOfMonth,
      endDate: endOfMonth,
      description: '${_getMonthName(month)} $year',
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

// Result of a financial query
class FinanceQueryResult {
  final double amount;
  final String currency;
  final Map<String, double>? breakdown;
  final String? additionalInfo;

  FinanceQueryResult({
    required this.amount,
    required this.currency,
    this.breakdown,
    this.additionalInfo,
  });
}

// Service to handle finance queries
class FinanceQueryService {
  final EntryService _entryService = EntryService();
  final AccountService _accountService = AccountService();
  final SettingService _settingService = SettingService();
  
  // Extract intent from a query string
  QueryIntent extractIntent(String query) {
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('spend') || 
        lowerQuery.contains('expense') || 
        lowerQuery.contains('cost')) {
      return QueryIntent.expenses;
    } else if (lowerQuery.contains('income') || 
               lowerQuery.contains('earn') ||
               lowerQuery.contains('revenue')) {
      return QueryIntent.income;
    } else if (lowerQuery.contains('save') || 
               lowerQuery.contains('saving')) {
      return QueryIntent.savings;
    } else if (lowerQuery.contains('balance') || 
               lowerQuery.contains('have') ||
               lowerQuery.contains('worth')) {
      return QueryIntent.balance;
    }
    
    return QueryIntent.unknown;
  }
  
  // Extract time range from a query string
  TimeRange extractTimeRange(String query) {
    final lowerQuery = query.toLowerCase();
    final now = DateTime.now();
    
    if (lowerQuery.contains('last month')) {
      return TimeRange.lastMonth();
    } else if (lowerQuery.contains('this month')) {
      return TimeRange.thisMonth();
    } else if (lowerQuery.contains('january')) {
      return TimeRange.specificMonth(1, now.year);
    } else if (lowerQuery.contains('february')) {
      return TimeRange.specificMonth(2, now.year);
    } else if (lowerQuery.contains('march')) {
      return TimeRange.specificMonth(3, now.year);
    } else if (lowerQuery.contains('april')) {
      return TimeRange.specificMonth(4, now.year);
    } else if (lowerQuery.contains('may')) {
      return TimeRange.specificMonth(5, now.year);
    } else if (lowerQuery.contains('june')) {
      return TimeRange.specificMonth(6, now.year);
    } else if (lowerQuery.contains('july')) {
      return TimeRange.specificMonth(7, now.year);
    } else if (lowerQuery.contains('august')) {
      return TimeRange.specificMonth(8, now.year);
    } else if (lowerQuery.contains('september')) {
      return TimeRange.specificMonth(9, now.year);
    } else if (lowerQuery.contains('october')) {
      return TimeRange.specificMonth(10, now.year);
    } else if (lowerQuery.contains('november')) {
      return TimeRange.specificMonth(11, now.year);
    } else if (lowerQuery.contains('december')) {
      return TimeRange.specificMonth(12, now.year);
    }
    
    // Default to this month if no time range is specified
    return TimeRange.thisMonth();
  }

  // Process a finance query - placeholder for now
  // This will be implemented with actual database calls later
  Future<FinanceQueryResult> processQuery(String query) async {
    final intent = extractIntent(query);
    final timeRange = extractTimeRange(query);
    
    // This is a placeholder implementation
    // In reality, this would call the EntryService to get real data
    switch (intent) {
      case QueryIntent.expenses:
        return FinanceQueryResult(
          amount: 1250.75,
          currency: 'USD',
          breakdown: {
            'Housing': 750.0,
            'Food': 320.0,
            'Transportation': 100.0,
            'Other': 80.75,
          },
        );
      
      case QueryIntent.income:
        return FinanceQueryResult(
          amount: 3200.0,
          currency: 'USD',
          breakdown: {
            'Salary': 3000.0,
            'Interest': 200.0,
          },
        );
      
      case QueryIntent.savings:
        return FinanceQueryResult(
          amount: 800.0,
          currency: 'USD',
          additionalInfo: '25% savings rate',
        );
        
      case QueryIntent.balance:
      case QueryIntent.unknown:
      default:
        return FinanceQueryResult(
          amount: 12500.0,
          currency: 'USD',
          additionalInfo: 'Total assets across all accounts',
        );
    }
  }
  
  // Format the query result into a readable message
  String formatQueryResult(QueryIntent intent, TimeRange timeRange, FinanceQueryResult result) {
    String response = '';
    
    switch (intent) {
      case QueryIntent.expenses:
        response = 'Based on your records, you spent ${_formatCurrency(result.amount, result.currency)} in ${timeRange.description}.';
        if (result.breakdown != null) {
          response += ' Your biggest expense categories were:';
          result.breakdown!.forEach((category, amount) {
            response += '\n• $category: ${_formatCurrency(amount, result.currency)}';
          });
        }
        break;
        
      case QueryIntent.income:
        response = 'Your income for ${timeRange.description} was ${_formatCurrency(result.amount, result.currency)}.';
        if (result.breakdown != null) {
          response += ' This came from:';
          result.breakdown!.forEach((source, amount) {
            response += '\n• $source: ${_formatCurrency(amount, result.currency)}';
          });
        }
        break;
        
      case QueryIntent.savings:
        response = 'You saved ${_formatCurrency(result.amount, result.currency)} in ${timeRange.description}.';
        if (result.additionalInfo != null) {
          response += ' ${result.additionalInfo}';
        }
        break;
        
      case QueryIntent.balance:
        response = 'Your current balance is ${_formatCurrency(result.amount, result.currency)}.';
        if (result.additionalInfo != null) {
          response += ' ${result.additionalInfo}';
        }
        break;
        
      case QueryIntent.unknown:
      default:
        response = 'I\'m not sure how to answer that financial question yet.';
        break;
    }
    
    return response;
  }
  
  String _formatCurrency(double amount, String currency) {
    // Simple currency formatter - can be expanded for different currencies
    return '$currency${amount.toStringAsFixed(2)}';
  }
} 
