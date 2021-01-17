import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:wasser/widgets/widgets.dart';
import 'package:intl/intl.dart';

class TrackUsageScreen extends StatefulWidget {
  final void Function(BuildContext context, int idx) navigator;

  TrackUsageScreen({this.navigator});

  @override
  _TrackUsageScreenState createState() => _TrackUsageScreenState();
}

class _TrackUsageScreenState extends State<TrackUsageScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usageService = WaterUsageDataService();

  final _sizedBoxSpace = SizedBox(
    height: 16,
  );

  DateTime _dateRecorded = DateTime.now();

  double _remainingBalance = 0;

  void _notify(String message, BuildContext context) async {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _validateRemainingBalance(String balance) {
    if (balance != null && balance.isNotEmpty && double.tryParse(balance) != null) return null;
    return "Please enter the correct number of litres";
  }

  void _onSaveUsageData(BuildContext context) async {
    try {
      if (!_formKey.currentState.validate()) return;
      _onLoading(context);
      var data = RemainingBalanceModel(balance: _remainingBalance, dateRecorded: _dateRecorded);
      await _usageService.saveRemainingWaterBalance(data);
      setState(() {
        _remainingBalance = 0;
        _dateRecorded = DateTime.now();
      });
      _notify("Water balance saved", context);
    } on Exception catch (e) {
      print("$e");
      _notify("Unknown error, please try again", context);
    } finally {
      Navigator.pop(context); //pop dialog
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: _dateRecorded,
        firstDate: _dateRecorded.subtract(Duration(days: 365)),
        lastDate: _dateRecorded);
    if (selectedDate != null && selectedDate != _dateRecorded)
      setState(() {
        _dateRecorded = selectedDate;
      });
  }

  _onBalanceChanged(BuildContext context, String val) {
    if (_formKey.currentState.validate()) {
      setState(() {
        _remainingBalance = double.parse(val);
      });
    }
  }

  void _onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  String humanReadableDate(DateTime dt) {
    return DateFormat("EEEE yyyy-MMM-dd HH:mm:ss").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track usage"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${humanReadableDate(_dateRecorded)}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Text(
                      "Change date",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                )
              ],
            ),
            _sizedBoxSpace,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter the remaining balance in litres',
                  labelText: 'Remaining balance',
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
                validator: _validateRemainingBalance,
                onChanged: (val) => _onBalanceChanged(context, val),
              ),
            ),
            _sizedBoxSpace,
            Container(
              height: 40,
              width: 220,
              child: ElevatedButton.icon(
                label: Text("Save"),
                icon: Icon(
                  Icons.save,
                  size: 14,
                ),
                onPressed: () => _onSaveUsageData(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
