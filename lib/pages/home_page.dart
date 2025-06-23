import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'detail_transaction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.monthlyTransactions;
    final pemasukan = transactionProvider.totalPemasukanBulanan;
    final pengeluaran = transactionProvider.totalPengeluaranBulanan;
    final sisaUang = transactionProvider.sisaUangBulanan;

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Bulanan
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF185A9D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: Pemasukan dan Pengeluaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pemasukan
                        GestureDetector(
                          onTap: () {
                            final pemasukanList =
                                transactions
                                    .where((tx) => !tx.isExpense)
                                    .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailTransactionPage(
                                      title: "Daftar Pemasukan",
                                      transactions: pemasukanList,
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pemasukan",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Rp. ${pemasukan.toStringAsFixed(0)}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Pengeluaran
                        GestureDetector(
                          onTap: () {
                            final pengeluaranList =
                                transactions
                                    .where((tx) => tx.isExpense)
                                    .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailTransactionPage(
                                      title: "Daftar Pengeluaran",
                                      transactions: pengeluaranList,
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.upload,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pengeluaran",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Rp. ${pengeluaran.toStringAsFixed(0)}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sisa Uang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sisa Uang Bulan Ini",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Rp. ${sisaUang.toStringAsFixed(0)}",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Judul Transaksi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Transaksi Bulan Ini",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Daftar Transaksi
            ...transactions.map((tx) {
              String formattedDate = DateFormat('dd MMM yyyy').format(tx.date);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 10,
                  color: const Color(0xFF185A9D),
                  child: ListTile(
                    title: Text(
                      "Rp. ${tx.amount.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.category,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        transactionProvider.deleteTransactionFromMonthly(tx);
                      },
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        tx.isExpense ? Icons.upload : Icons.download,
                        color: tx.isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
