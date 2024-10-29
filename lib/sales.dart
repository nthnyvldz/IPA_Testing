import 'package:counter/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:counter/db/database_helper.dart'; // Adjust import path as per your project structure

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late Future<List<Map<String, dynamic>>> _salesDataFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _salesData = []; // Stores all sales data
  List<Map<String, dynamic>> _filteredSalesData = [];

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    // Fetch sales data from database
    _salesDataFuture = DatabaseHelper.instance.fetchSales();
    _salesData = await _salesDataFuture;
    setState(() {
      _filteredSalesData =
          _salesData; // Initialize filtered data with all sales data
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF5E1), // Cream color background
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      'assets/images/logo.png', // Ensure this path is correct
                      width: MediaQuery.of(context).size.width < 430 ? 40 : 50,
                      height: MediaQuery.of(context).size.width < 430 ? 40 : 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Fingerlings Counter 2.0',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
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

              // Sales History Title
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
                      Icons.monetization_on_outlined,
                      size: MediaQuery.of(context).size.width < 430 ? 20 : 24,
                      color: Colors.green[900],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SALES HISTORY",
                      style: GoogleFonts.robotoCondensed(
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

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
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
                          _filteredSalesData =
                              _salesData; // Reset to show all data
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _filterSales(value);
                  },
                ),
              ),

              // Sales List
              Expanded(
                child: _filteredSalesData.isEmpty
                    ? const Center(child: Text('No sales data available'))
                    : ListView.builder(
                        itemCount: _filteredSalesData.length,
                        itemBuilder: (context, index) {
                          final sale = _filteredSalesData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              color: Colors.black.withOpacity(0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 5,
                              child: ListTile(
                                title: Text(
                                  'Batch Number: ${sale['batch_number']}',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize:
                                        MediaQuery.of(context).size.width < 430
                                            ? 18
                                            : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Count: ${sale['total_count']}',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    430
                                                ? 16
                                                : 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    Text(
                                      'Price Sold: ${sale['price_sold']}',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    430
                                                ? 16
                                                : 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    Text(
                                      'Date Sold: ${sale['date_sold']}',
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    430
                                                ? 16
                                                : 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.green[900]),
                                      onPressed: () {
                                        _showUpdateDialog(sale);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red[900]),
                                      onPressed: () {
                                        _confirmDelete(context, sale);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  void _filterSales(String searchQuery) {
    setState(() {
      if (searchQuery.isEmpty) {
        _filteredSalesData = _salesData; // Reset to show all data
      } else {
        _filteredSalesData = _salesData
            .where((sale) => sale['batch_number']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _showUpdateDialog(Map<String, dynamic> sale) {
    TextEditingController priceSoldController =
        TextEditingController(text: sale['price_sold'].toString());
    TextEditingController dateSoldController =
        TextEditingController(text: sale['date_sold'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside the text fields
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding here
            child: AlertDialog(
              title: Center(
                child: Text(
                  'Update Sale',
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.green[900],
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Batch Number: ${sale['batch_number']}',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.green[900],
                        ),
                      ),
                      Text(
                        'Total Count: ${sale['total_count']}',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.green[900],
                    ),
                    controller: priceSoldController,
                    decoration: InputDecoration(
                      labelText: 'Price Sold',
                      labelStyle: GoogleFonts.robotoCondensed(
                        color: Colors.green[900],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[900]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[900]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.green[900],
                    ),
                    controller: dateSoldController,
                    decoration: InputDecoration(
                      labelText: 'Date Sold',
                      labelStyle: GoogleFonts.robotoCondensed(
                        color: Colors.green[900],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[900]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[900]!),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    // Update the record in the database
                    await DatabaseHelper.instance.updateSale({
                      'id': sale['id'],
                      'batch_number': sale['batch_number'],
                      'total_count': sale['total_count'],
                      'price_sold': priceSoldController.text,
                      'date_sold': dateSoldController.text,
                    });

                    // Reload sales data
                    await _loadSalesData();

                    // Close the dialog
                    Navigator.of(context).pop();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Record updated successfully!',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green[900],
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[900],
                  ),
                  child: Text(
                    'Save',
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
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> sale) {
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
            'Are you sure you want to delete this sale?',
            style: GoogleFonts.robotoCondensed(
              color: Colors.green[900],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Delete the record from the database
                await DatabaseHelper.instance.deleteSale(sale['id']);

                // Reload sales data
                await _loadSalesData();

                // Close the dialog
                Navigator.of(context).pop();

                // Show success message
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
