import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromCurrency = 'USD';
  String forCurrency = 'PLN';
  double rate = 4.0; // Przykładowy kurs
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = ['USD', 'PLN', 'EUR', 'GBP']; // Przykładowe waluty

  @override
  void initState() {
    super.initState();
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
                    SizedBox(
                      width: 120, // Określamy szerokość, by dropdown miał odpowiedni rozmiar
                      child: DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // Logika swapowania walut
                          String temp = fromCurrency;
                          fromCurrency = forCurrency;
                          forCurrency = temp;
                        });
                      },
                      icon: Icon(
                        Icons.swap_horiz,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 120, // Określamy szerokość dla drugiego dropdown
                      child: DropdownButton<String>(
                        value: forCurrency,
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        items: currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            forCurrency = newValue!;
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
