import 'package:flutter/material.dart';
import 'package:taskzoo/widgets/tasks/task.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

const double appBarSize = 40.0;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onAddTaskPressed;
  final ValueNotifier<String> selectedSchedule;
  final Function(List<String>) onUpdateSelectedTags;
  Stream<List<Task>> tasks;

  CustomAppBar({
    Key? key,
    required this.onAddTaskPressed,
    required this.selectedSchedule,
    required this.onUpdateSelectedTags,
    required this.tasks,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int selectedIndex = 0;
  List<String> selectedTags = [];

  void selectButton(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        widget.selectedSchedule.value = 'Daily';
      } else if (index == 1) {
        widget.selectedSchedule.value = 'Weekly';
      } else if (index == 2) {
        widget.selectedSchedule.value = 'Monthly';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: widget.tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final tasks = snapshot.data ?? [];
          return AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: Row(
              children: [
                CircleButton(
                  key: ValueKey('D-${selectedIndex == 0}'), // add ValueKey
                  label: 'D',
                  isSelected: selectedIndex == 0,
                  onTap: () => selectButton(0),
                ),
                SizedBox(width: Dimensions.of(context).insets.medium),
                CircleButton(
                  key: ValueKey('W-${selectedIndex == 1}'),
                  label: 'W',
                  isSelected: selectedIndex == 1,
                  onTap: () => selectButton(1),
                ),
                SizedBox(width: Dimensions.of(context).insets.medium),
                CircleButton(
                  key: ValueKey('M-${selectedIndex == 2}'),
                  label: 'M',
                  isSelected: selectedIndex == 2,
                  onTap: () => selectButton(2),
                ),
                const Spacer(),
                IconButton(
                  iconSize: appBarSize / 1.5,
                  icon: const Icon(Icons.keyboard_control),
                  color: Theme.of(context).indicatorColor,
                  onPressed: () {
                    showTagDropdown(
                        context, selectedTags, tasks); // Pass tasks here
                  },
                ),
                Container(
                  width: 1,
                  height: appBarSize,
                  color: Theme.of(context).indicatorColor,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                    iconSize: appBarSize / 1.5,
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).indicatorColor,
                    onPressed: widget.onAddTaskPressed)
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(); // Loading indicator
        }
      },
    );
  }

  void showTagDropdown(
      BuildContext context, List<String> selectedTags, List<Task> tasks) {
    final List<String> allTags = getAllTags(tasks);
    bool hasTasks = allTags.isNotEmpty;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.of(context).radii.larger),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.of(context).radii.larger),
                  topRight: Radius.circular(Dimensions.of(context).radii.larger),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.all(Dimensions.of(context).insets.medium),
                    child: Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hasTasks)
                    Expanded(
                      child: ListView.builder(
                        itemCount: allTags.length,
                        itemBuilder: (BuildContext context, int index) {
                          final tag = allTags[index];
                          final bool isSelected = selectedTags.contains(tag);
                          return ListTile(
                            title: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              activeColor: Theme.of(context).indicatorColor,
                              checkColor: Theme.of(context).cardColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedTags.add(tag);
                                  } else {
                                    selectedTags.remove(tag);
                                  }
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedTags.remove(tag);
                                } else {
                                  selectedTags.add(tag);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  if (!hasTasks)
                    Padding(
                      padding:
                          EdgeInsets.all(Dimensions.of(context).insets.medium),
                      child: Text(
                        'Add Tasks To Filter By Tags',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        Dimensions.of(context).insets.medium,
                        Dimensions.of(context).insets.smaller,
                        Dimensions.of(context).insets.medium,
                        Dimensions.of(context).insets.larger),
                    child: ElevatedButton(
                      onPressed: hasTasks
                          ? () {
                              widget.onUpdateSelectedTags(selectedTags);
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).indicatorColor,
                        foregroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.of(context).radii.larger),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.of(context).insets.medium,
                            horizontal: Dimensions.of(context).insets.larger),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<String> getAllTags(List<Task> tasks) {
    final Set<String> allTags = Set<String>();

    for (var task in tasks) {
      allTags.add(task.tag);
    }

    return allTags.toList();
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CircleButton({
    Key? key, // Add key parameter
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key); // Pass key to superclass

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: appBarSize,
        height: appBarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).indicatorColor
                : Theme.of(context).cardColor,
            width: 2,
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).indicatorColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
