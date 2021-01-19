import 'package:flutter/material.dart';
import 'package:wasser/models/models_proxy.dart';
import 'package:wasser/services/services_proxy.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrackUsageScreen extends StatefulWidget {
  final void Function(BuildContext context, int idx) navigator;

  TrackUsageScreen({this.navigator});

  @override
  _TrackUsageScreenState createState() => _TrackUsageScreenState();
}

class _TrackUsageScreenState extends State<TrackUsageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usageService = WaterUsageDataService();
  final _balanceController = TextEditingController();
  final _sizedBoxSpace = SizedBox(
    height: 16,
  );

  bool _isLoading = false;
  DateTime _dateRecorded = DateTime.now();
  double _remainingBalance = 0;

  @override
  void initState() {
    super.initState();
    _balanceController.addListener(() {
      print("Controller changed ${_balanceController.text}");
    });
  }

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
      setState(() {
        _isLoading = true;
      });
      var remainingBalance = double.parse(_balanceController.text);
      var dateOnly = DateTime(_dateRecorded.year, _dateRecorded.month, _dateRecorded.day);
      var data = RemainingBalanceModel(balance: remainingBalance, dateRecorded: dateOnly);
      await _usageService.saveRemainingWaterBalance(data);
      _balanceController.clear();
      _notify("Water balance saved", context);
      context.read<BottomNavState>().setActivePageIdx(0);
    } on Exception catch (e) {
      print("$e");
      _notify("Unknown error, please try again", context);
    } finally {
      // Navigator.pop(context); //pop dialog
      setState(() {
        _isLoading = false;
        _remainingBalance = 0;
        _dateRecorded = DateTime.now();
      });
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
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
                    onTap: () => _showDatePicker(context),
                  ),
                )
              ],
            ),
            _sizedBoxSpace,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter the remaining balance in litres',
                  labelText: 'Remaining balance',
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
                validator: _validateRemainingBalance,
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
            ),
            _sizedBoxSpace,
            _isLoading ? LinearProgressIndicator() : SizedBox()
          ],
        ),
      ),
    );
  }
}
