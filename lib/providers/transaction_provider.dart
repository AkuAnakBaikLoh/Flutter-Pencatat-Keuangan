import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _allTransactions = [];
  DateTime _selectedDate = DateTime.now();

  /// Getter: Transaksi harian berdasarkan tanggal yang dipilih
  List<TransactionModel> get transactions =>
      _allTransactions
          .where(
            (tx) =>
                tx.date.year == _selectedDate.year &&
                tx.date.month == _selectedDate.month &&
                tx.date.day == _selectedDate.day,
          )
          .toList();

  /// Getter: Transaksi bulanan berdasarkan bulan & tahun yang dipilih
  List<TransactionModel> get monthlyTransactions =>
      _allTransactions
          .where(
            (tx) =>
                tx.date.year == _selectedDate.year &&
                tx.date.month == _selectedDate.month,
          )
          .toList();

  /// Total pemasukan harian
  double get totalPemasukan => transactions
      .where((tx) => !tx.isExpense)
      .fold(0, (sum, tx) => sum + tx.amount);

  /// Total pengeluaran harian
  double get totalPengeluaran => transactions
      .where((tx) => tx.isExpense)
      .fold(0, (sum, tx) => sum + tx.amount);

  /// Total pemasukan bulanan
  double get totalPemasukanBulanan => monthlyTransactions
      .where((tx) => !tx.isExpense)
      .fold(0, (sum, tx) => sum + tx.amount);

  /// Total pengeluaran bulanan
  double get totalPengeluaranBulanan => monthlyTransactions
      .where((tx) => tx.isExpense)
      .fold(0, (sum, tx) => sum + tx.amount);

  /// Sisa uang bulanan
  double get sisaUangBulanan => totalPemasukanBulanan - totalPengeluaranBulanan;

  /// Getter tanggal yang dipilih
  DateTime get selectedDate => _selectedDate;

  /// Setter tanggal yang dipilih
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Load semua transaksi dari Hive
  void loadTransactions() {
    final box = Hive.box<TransactionModel>('transactions');
    _allTransactions = box.values.toList();
    notifyListeners();
  }

  /// Tambahkan transaksi baru ke Hive
  void addTransaction(TransactionModel transaction) async {
    final box = Hive.box<TransactionModel>('transactions');
    await box.add(transaction);
    _allTransactions = box.values.toList();
    notifyListeners();
  }

  /// Hapus transaksi berdasarkan index dari transaksi harian
  void deleteTransaction(int index) async {
    final filtered = transactions;
    if (index >= 0 && index < filtered.length) {
      final txToDelete = filtered[index];
      final box = Hive.box<TransactionModel>('transactions');
      final keyToDelete = box.keys.firstWhere(
        (key) => box.get(key) == txToDelete,
        orElse: () => null,
      );
      if (keyToDelete != null) {
        await box.delete(keyToDelete);
        _allTransactions = box.values.toList();
        notifyListeners();
      }
    }
  }

  /// Hapus transaksi berdasarkan objek (misalnya dari monthlyTransactions)
  void deleteTransactionFromMonthly(TransactionModel tx) async {
    final box = Hive.box<TransactionModel>('transactions');
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key) == tx,
      orElse: () => null,
    );
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
      _allTransactions = box.values.toList();
      notifyListeners();
    }
  }
}
