import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MassConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mass Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MassConverterHomePage(),
    );
  }
}

class MassConverterHomePage extends StatefulWidget {
  @override
  _MassConverterHomePageState createState() => _MassConverterHomePageState();
}

class _MassConverterHomePageState extends State<MassConverterHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'g';
  String _toUnit = 'kg';
  double _result = 0.0;

  // Define the units and their conversion factors relative to grams
  final Map<String, double> _units = {
    't': 1000000,     // Tonne
    'kg': 1000,       // Kilogram
    'hg': 100,        // Hectogram
    'dag': 10,        // Decagram
    'g': 1,           // Gram
    'dg': 0.1,        // Decigram
    'cg': 0.01,       // Centigram
    'mg': 0.001,      // Milligram
  };

  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 0.0;
      });
      return;
    }

    double baseValue = input * _units[_fromUnit]!; // Convert to grams
    double convertedValue = baseValue / _units[_toUnit]!; // Convert to target unit

    setState(() {
      _result = convertedValue;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add listener to perform conversion when input changes
    _controller.addListener(_convert);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      onChanged: onChanged,
      items: _units.keys.map<DropdownMenuItem<String>>((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
    );
  }

  String _getUnitFullName(String unit) {
    switch (unit) {
      case 't':
        return 'Tonne';
      case 'kg':
        return 'Kilogram';
      case 'hg':
        return 'Hectogram';
      case 'dag':
        return 'Decagram';
      case 'g':
        return 'Gram';
      case 'dg':
        return 'Decigram';
      case 'cg':
        return 'Centigram';
      case 'mg':
        return 'Milligram';
      default:
        return unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mass Converter'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input Field
              TextField(
                controller: _controller,
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // From Unit Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'From:',
                    style: TextStyle(fontSize: 16),
                  ),
                  _buildDropdown(_fromUnit, (String? newValue) {
                    setState(() {
                      _fromUnit = newValue!;
                      _convert();
                    });
                  }),
                ],
              ),
              SizedBox(height: 20),
              // To Unit Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'To:',
                    style: TextStyle(fontSize: 16),
                  ),
                  _buildDropdown(_toUnit, (String? newValue) {
                    setState(() {
                      _toUnit = newValue!;
                      _convert();
                    });
                  }),
                ],
              ),
              SizedBox(height: 40),
              // Result Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_controller.text.isEmpty ? '0' : _controller.text} ${_getUnitFullName(_fromUnit)} = ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$_result ${_getUnitFullName(_toUnit)}',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
