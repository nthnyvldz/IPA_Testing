import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:counter/sales.dart';
import 'package:counter/homescreen.dart';

class ResultsTableScreen extends StatefulWidget {
  const ResultsTableScreen({super.key});

  @override
  _ResultsTableScreenState createState() => _ResultsTableScreenState();
}

class _ResultsTableScreenState extends State<ResultsTableScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the current focus node (dismiss keyboard)
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFF5E1), // Cream color background
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width < 370
                      ? 10
                      : MediaQuery.of(context).size.width > 420
                          ? 20
                          : 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width < 430 ? 40 : 50,
                      height: MediaQuery.of(context).size.width < 430 ? 40 : 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Fingerlings Counter 2.0',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Roboto Condensed',
                        fontSize:
                            MediaQuery.of(context).size.width < 430 ? 20 : 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Divider(
                  color: Colors.green[900],
                  thickness: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.green[900],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(), // Navigate to CounterScreen
                          ),
                        );
                      },
                    ),
                    Icon(
                      Icons.insert_chart,
                      size: MediaQuery.of(context).size.width < 430 ? 20 : 24,
                      color: Colors.green[900],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "COUNTER HISTORY",
                      style: GoogleFonts.getFont(
                        'Roboto Condensed',
                        fontSize:
                            MediaQuery.of(context).size.width < 430 ? 20 : 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Divider(
                  color: Colors.green[900],
                  thickness: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Batch Number',
                    labelStyle: TextStyle(
                      color: Colors.green[900],
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green[900]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green[900]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green[900]!,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper.instance.fetchResults(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Records available'));
                    }

                    final results = snapshot.data!;
                    final filteredResults = results.where((result) {
                      return result['batch_number']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filteredResults.isEmpty) {
                      return const Center(child: Text('No Records available'));
                    }

                    return ListView.builder(
                      itemCount: filteredResults.length,
                      itemBuilder: (context, index) {
                        final result = filteredResults[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Card(
                            color: Colors.black.withOpacity(
                                0.01), // Transparent black background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Batch Number: ${result['batch_number']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  430
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900],
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Count: ${result['total_count']}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  430
                                              ? 14
                                              : 16,
                                          color: Colors.green[900],
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _showAddSaleDialog(
                                              context,
                                              result['batch_number'],
                                              result['total_count']);
                                        },
                                        icon: const Icon(Icons.add),
                                        color: Colors.green[900],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _confirmDelete(
                                              context, result['batch_number']);
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red[900],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddSaleDialog(
      BuildContext context, int batchNumber, int totalCount) async {
    TextEditingController priceController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // Unfocus the current focus node (dismiss keyboard)
            FocusScope.of(context).unfocus();
          },
          child: AlertDialog(
            title: Center(
              child: Text(
                'Add Sale',
                style: GoogleFonts.getFont('Roboto Condensed',
                    color: Colors.green[900]),
              ),
            ),
            content: SingleChildScrollView(
              // Scroll in case of overflow
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Batch Number: $batchNumber',
                            style: GoogleFonts.getFont('Roboto Condensed',
                                color: Colors.green[900])),
                        Text('Total Count: $totalCount',
                            style: GoogleFonts.getFont('Roboto Condensed',
                                color: Colors.green[900])),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: GoogleFonts.getFont('Roboto Condensed',
                          color: Colors.green[900]),
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price Sold',
                        labelStyle: GoogleFonts.getFont('Roboto Condensed',
                            color: Colors.green[900]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[900]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[900]!),
                        ),
                      ),
                      keyboardType:
                          TextInputType.number, // Specify keyboard type
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: GoogleFonts.getFont('Roboto Condensed',
                          color: Colors.green[900]),
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Date Sold',
                        labelStyle: GoogleFonts.getFont('Roboto Condensed',
                            color: Colors.green[900]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[900]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[900]!),
                        ),
                      ),
                      keyboardType: TextInputType.datetime, // Date input type
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Save sale data to database
                  _saveSale(context, batchNumber, totalCount,
                      priceController.text, dateController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    Text('Cancel', style: TextStyle(color: Colors.green[900]!)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveSale(BuildContext context, int batchNumber, int totalCount,
      String priceSold, String dateSold) async {
    Map<String, dynamic> sale = {
      'batch_number': batchNumber,
      'total_count': totalCount,
      'price_sold': priceSold,
      'date_sold': dateSold,
    };

    await DatabaseHelper.instance.insertSale(sale);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SalesScreen(), // Navigate to CounterScreen
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Sale added successfully!',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green[900],
    ));
  }

  void _confirmDelete(BuildContext context, int batchNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: GoogleFonts.robotoCondensed(
              color: Colors.green[900],
            ),
          ),
          content: Text(
            'Are you sure you want to delete batch number $batchNumber?',
            style: GoogleFonts.robotoCondensed(
              color: Colors.green[900],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteResult(batchNumber);

                setState(() {});

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Record deleted successfully!',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green[900],
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.green[900],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
