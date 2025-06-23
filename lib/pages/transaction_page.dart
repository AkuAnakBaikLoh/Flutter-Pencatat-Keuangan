import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  List<String> list = [
    'Makan dan Minum',
    'Liburan atau Hiburan',
    'Transportasi',
    'Gajian',
    'Tabungan',
  ];
  late String dropDownValue = list.first;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF185A9D),
        title: Text(
          "Tambah Transaksi",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Switch Pemasukan/Pengeluaran
                Row(
                  children: [
                    Switch(
                      value: isExpense,
                      onChanged: (bool value) {
                        setState(() {
                          isExpense = value;
                        });
                      },
                      inactiveTrackColor: Colors.green[200],
                      inactiveThumbColor: Colors.green,
                      activeColor: Colors.red,
                    ),
                    Text(
                      isExpense ? 'Pengeluaran' : 'Pemasukan',
                      style: GoogleFonts.montserrat(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Jumlah
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Jumlah",
                    border: const OutlineInputBorder(),
                    labelStyle: GoogleFonts.montserrat(),
                  ),
                ),
                const SizedBox(height: 20),
                // Dropdown Kategori
                Text('Keterangan', style: GoogleFonts.montserrat(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: dropDownValue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items:
                      list.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.montserrat()),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        dropDownValue = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Tanggal
                TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Masukkan Tanggal",
                    border: const OutlineInputBorder(),
                    labelStyle: GoogleFonts.montserrat(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MMM-dd',
                      ).format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF185A9D),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      if (amountController.text.isNotEmpty &&
                          dateController.text.isNotEmpty) {
                        final transaction = TransactionModel(
                          isExpense: isExpense,
                          category: dropDownValue,
                          amount: int.parse(amountController.text),
                          date: DateFormat(
                            'yyyy-MMM-dd',
                          ).parse(dateController.text),
                        );

                        Provider.of<TransactionProvider>(
                          context,
                          listen: false,
                        ).addTransaction(transaction);

                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      "Simpan",
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
