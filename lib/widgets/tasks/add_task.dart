import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/tasks/task.dart';
import 'package:taskzoo/widgets/isar_service.dart';

const maxCharLimit = 20;

class AddTaskSheet extends StatefulWidget {
  final IsarService service;
  const AddTaskSheet(this.service, {Key? key}) : super(key: key);

  @override
  _AddTaskSheetState createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  final List<bool> _daysOfWeek = List.filled(7, false);
  bool _biDaily = false;
  bool _weekly = false;
  bool _monthly = false;
  bool _isExpanded = false;
  String _selectedOption = 'Daily';
  int _timesPerMonth = 1;
  int _timesPerWeek = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(Dimensions.of(context).radii.largest),
      topRight: Radius.circular(Dimensions.of(context).radii.largest),
    ),
    color: Theme.of(context).cardColor, // Set the background color for the container to mimic the Card's default color.
  ),
  child: Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'New Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).indicatorColor,
              ),
            ),
            SizedBox(height: Dimensions.of(context).insets.medium),
            _buildSelectedOptionTextBox(),
            SizedBox(height: Dimensions.of(context).insets.medium),
            _buildTextField('Task Name', _titleController),
            SizedBox(height: Dimensions.of(context).insets.medium),
            _buildTextField('Tag Name', _tagController),
            SizedBox(height: Dimensions.of(context).insets.medium),
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: const EdgeInsets.all(0),
              dividerColor: Colors.transparent,
              expansionCallback: (int index, bool isExpanded) =>
                  setState(() => _isExpanded = !isExpanded),
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text('Additional Options',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  },
                  body: Column(
                    children: [
                      _buildDaySelector(),
                      Divider(color: Theme.of(context).dividerColor),
            SizedBox(height: Dimensions.of(context).insets.medium),
                      _buildBiDailySwitch(),
                      Divider(color: Theme.of(context).dividerColor),
                      _buildWeeklySwitch(),
                      if (_weekly) _buildDaysPerWeekSelector(),
                      Divider(color: Theme.of(context).dividerColor),
                      _buildMonthlySwitch(),
                      if (_monthly) _buildDaysPerMonthSelector()
                    ],
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),
            SizedBox(height: Dimensions.of(context).insets.medium),
            _buildSubmitButton(context),
          ],
        ),
      ),
    ),
  ),
);

  }

  Widget _buildSelectedOptionTextBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        'Task Days: $_selectedOption',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      maxLength: maxCharLimit,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Theme.of(context).indicatorColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: _biDaily || _weekly || _monthly ? 0.5 : 1.0,
          child: const Text(
            'Select days of the week for the task:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 7; i++)
              ChoiceChip(
                label: Opacity(
                  opacity: _biDaily || _weekly || _monthly ? 0.5 : 1.0,
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                    style: TextStyle(
                        color: _daysOfWeek[i]
                            ? Theme.of(context).cardColor
                            : Theme.of(context).indicatorColor),
                  ),
                ),
                selected: _daysOfWeek[i],
                selectedColor: Theme.of(context).indicatorColor,
                onSelected: _biDaily || _weekly || _monthly
                    ? null
                    : (selected) {
                        setState(() {
                          _daysOfWeek[i] = selected;
                          if (_daysOfWeek.contains(true)) {
                            _biDaily = false;
                            _weekly = false;
                            _monthly = false;
                            _selectedOption = 'Custom';
                          }
                          updateSelectionOptionAndState();
                        });
                      },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBiDailySwitch() {
    return IgnorePointer(
      ignoring: _daysOfWeek.contains(true) || _weekly || _monthly,
      child: Opacity(
        opacity: _daysOfWeek.contains(true) || _weekly || _monthly ? 0.5 : 1.0,
        child: SwitchListTile(
          title: const Text(
            'Every 2 Days',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          value: _biDaily,
          onChanged: _daysOfWeek.contains(true)
              ? null
              : (value) {
                  setState(() {
                    _biDaily = value;
                    if (_biDaily) {
                      _daysOfWeek.fillRange(0, 7, false);
                      _weekly = false;
                      _monthly = false;
                      _selectedOption = 'BiDaily';
                    }

                    updateSelectionOptionAndState();
                  });
                },
          activeColor: Theme.of(context).indicatorColor,
        ),
      ),
    );
  }

  Widget _buildWeeklySwitch() {
    return IgnorePointer(
      ignoring: _daysOfWeek.contains(true) || _biDaily || _monthly,
      child: Opacity(
        opacity: _daysOfWeek.contains(true) || _biDaily || _monthly ? 0.5 : 1.0,
        child: SwitchListTile(
          title: const Text(
            'Weekly',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          value: _weekly,
          onChanged: _daysOfWeek.contains(true)
              ? null
              : (value) {
                  setState(() {
                    _weekly = value;
                    if (_weekly) {
                      _daysOfWeek.fillRange(0, 7, false);
                      _biDaily = false;
                      _monthly = false;
                      _selectedOption = 'Weekly';
                    }

                    updateSelectionOptionAndState();
                  });
                },
          activeColor: Theme.of(context).indicatorColor,
        ),
      ),
    );
  }

  Widget _buildMonthlySwitch() {
    return IgnorePointer(
      ignoring: _daysOfWeek.contains(true) || _biDaily || _weekly,
      child: Opacity(
        opacity: _daysOfWeek.contains(true) || _biDaily || _weekly ? 0.5 : 1.0,
        child: SwitchListTile(
          title: const Text(
            'Monthly',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          value: _monthly,
          onChanged: _daysOfWeek.contains(true)
              ? null
              : (value) {
                  setState(() {
                    _monthly = value;
                    if (_monthly) {
                      _daysOfWeek.fillRange(0, 7, false);
                      _biDaily = false;
                      _weekly = false;
                      _selectedOption = 'Monthly';
                    }

                    updateSelectionOptionAndState();
                  });
                },
          activeColor: Theme.of(context).indicatorColor,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).indicatorColor,
        foregroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
      ),
      child: const Text('Add Task'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // create a new Task object with your form data
          final newTask = Task(
            title: _titleController.text,
            tag: _tagController.text,
            schedule: getPageState(_daysOfWeek, _biDaily, _weekly, _monthly),
            daysOfWeek: _daysOfWeek,
            biDaily: _biDaily,
            weekly: _weekly,
            monthly: _monthly,
            timesPerMonth: _timesPerMonth,
            timesPerWeek: _timesPerWeek,
            isCompleted:
                false, // default values for properties not included in the form
            streakCount: 0,
            longestStreak: 0,
            isMeantForToday: true,
            currentCycleCompletions: 0,
            last30DaysDates: [],
            completionCount30days: 0,
            completedDates: [],
            previousDate: getMidnightIso8601String(),
            nextCompletionDate: getMidnightIso8601String(),
            isStreakContinued: false,
            piecesObtained: 0,
          );
          // add the new Task object to the database
          widget.service.saveTask(newTask);
          addCompletionCountEntry();

          // then navigate back
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildDaysPerWeekSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Days per Week:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _timesPerWeek > 1
                  ? () {
                      setState(() {
                        _timesPerWeek--;
                      });
                    }
                  : null,
            ),
            Text(
              '$_timesPerWeek',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _timesPerWeek++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysPerMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Days per Month:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _timesPerMonth > 1
                  ? () {
                      setState(() {
                        _timesPerMonth--;
                      });
                    }
                  : null,
            ),
            Text(
              '$_timesPerMonth',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _timesPerMonth++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  String getPageState(
    List<bool> daysOfWeek,
    bool biDaily,
    bool weekly,
    bool monthly,
  ) {
    if (daysOfWeek.any((day) => day == true)) {
      return 'Weekly';
    } else if (weekly) {
      return 'Weekly';
    } else if (monthly) {
      return 'Monthly';
    } else if (biDaily) {
      return 'Daily';
    } else {
      return 'Daily';
    }
  }

  void updateSelectedOption() {
    if (_daysOfWeek.contains(true)) {
      _selectedOption = 'Custom';
    } else if (_biDaily) {
      _selectedOption = 'BiDaily';
    } else if (_weekly) {
      _selectedOption = 'Weekly';
    } else if (_monthly) {
      _selectedOption = 'Monthly';
    } else {
      _selectedOption = 'Daily';
    }
  }

  void updateSelectionOptionAndState() {
    setState(() {
      updateSelectedOption();
    });
  }

  String getMidnightIso8601String() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day, 0, 0, 0);
    String iso8601String = midnight.toIso8601String();
    return iso8601String;
  }

  void addCompletionCountEntry() {
    widget.service.updateDailyCompletionEntry(false);
  }
}
