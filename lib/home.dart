import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromCurrency = 'USD';
  String forCurrency = 'PLN';
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];
  bool isLoading = true;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    _getCurrencies();
  }

  Future<void> _getCurrencies() async {
    if (!isFetching) {
      setState(() {
        isFetching = true;
      });
      try {
        var response = await http.get(Uri.parse("https://api.exchangerate-api.com/v4/latest/USD"));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          setState(() {
            currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
            rate = data['rates'][forCurrency];
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load currencies');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error collecting data: $e");
      } finally {
        setState(() {
          isFetching = false;
        });
      }
    }
  }

  Future<void> _getRate() async {
    try {
      var response = await http.get(Uri.parse("https://api.exchangerate-api.com/v4/latest/$fromCurrency"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          rate = data['rates'][forCurrency];
        });
      } else {
        throw Exception('Failed to load rate');
      }
    } catch (e) {
      print("Error downloading exchange rate: $e");
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = forCurrency;
      forCurrency = temp;
      _getRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c3e50),
      appBar: AppBar(
        backgroundColor: Color(0xFF273746),
        title: Text('Currency Converter'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                    ),
                  ),
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        total = double.parse(value) * rate;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dropdown for "fromCurrency"
                    SizedBox(
                      width: 120,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF2c3e50),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    ),
                    // Swap button
                    IconButton(
                      onPressed: _swapCurrencies,
                      icon: Icon(
                        Icons.swap_horiz,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // Dropdown for "toCurrency"
                    SizedBox(
                      width: 120,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButton<String>(
                        value: forCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF2c3e50),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            forCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Rate $rate",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '${total.toStringAsFixed(3)}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
