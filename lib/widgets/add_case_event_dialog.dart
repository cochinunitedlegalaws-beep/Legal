import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/case_calendar_screen.dart' show CaseEvent;

/// A dialog that allows users to create a calendar event from a case or add a new event.
class AddCaseEventDialog extends StatefulWidget {
  final List<CaseEvent> existingEvents;
  final Function(CaseEvent) onEventAdded;
  final List<String>? availableCases; // List of case IDs for linking

  const AddCaseEventDialog({
    Key? key,
    required this.existingEvents,
    required this.onEventAdded,
    this.availableCases,
  }) : super(key: key);

  @override
  State<AddCaseEventDialog> createState() => _AddCaseEventDialogState();
}

class _AddCaseEventDialogState extends State<AddCaseEventDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String _eventTitle = '';
  String _eventType = 'Hearing';
  String _location = '';
  String _attendees = '';
  String _linkedCaseId = '';

  final List<String> _eventTypes = ['Hearing', 'Deadline', 'Consultation'];
  final List<String> _commonVenues = [
    'Cochin HQ Conference Room A',
    'Cochin HQ Conference Room B',
    'Cochin HQ Main Cabin',
    'Kerala High Court (Courtroom 1A)',
    'Kerala High Court (Courtroom 3B)',
    'Ernakulam District Court',
    'Income Tax Appellate Tribunal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: AppTheme.primaryColor,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: AppTheme.primaryColor,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _isFormValid() {
    return _eventTitle.isNotEmpty && _location.isNotEmpty;
  }

  void _submitEvent() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final timeString =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period.name.toUpperCase().startsWith('A') ? 'AM' : 'PM'}';

    final newEvent = CaseEvent(
      date: _selectedDate,
      time: timeString,
      title: _eventTitle,
      type: _eventType,
      location: _location.isNotEmpty ? _location : null,
      attendees: _attendees.isNotEmpty ? _attendees : null,
      caseId: _linkedCaseId.isNotEmpty ? _linkedCaseId : null,
    );

    widget.onEventAdded(newEvent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: 5,
                )
              ]
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(32, 24, 24, 24),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_available, color: AppTheme.primaryColor, size: 28),
                            const SizedBox(width: 16),
                            Text(
                              'ADD EVENT',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontFamily: 'Cinzel',
                                shadows: [Shadow(color: AppTheme.primaryColor.withValues(alpha: 0.5), blurRadius: 10)]
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                          onPressed: () => Navigator.pop(context),
                          hoverColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),

                  // Form content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Event Title
                        Text(
                          'EVENT TITLE *',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) => setState(() => _eventTitle = value),
                          decoration: InputDecoration(
                            hintText: 'e.g., High Court Hearing',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5), fontFamily: 'Montserrat'),
                            filled: true,
                            fillColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                        ),
                  const SizedBox(height: 16),

                        // Event Type
                        Text(
                          'EVENT TYPE',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _eventTypes.map((type) {
                            final isSelected = _eventType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _eventType = type);
                                }
                              },
                              selectedColor: AppTheme.primaryColor,
                              backgroundColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
                              checkmarkColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.white24),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.black : AppTheme.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontFamily: 'Montserrat'
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 16),

                  // Date and Time Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DATE',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: AppTheme.primaryColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TIME',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectTime(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedTime.format(context),
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'
                                      ),
                                    ),
                                    const Icon(
                                      Icons.access_time,
                                      color: AppTheme.primaryColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Location
                  Text(
                    'LOCATION *',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _commonVenues;
                      }
                      return _commonVenues
                          .where((venue) =>
                              venue.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    onSelected: (String selection) {
                      setState(() => _location = selection);
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode,
                        onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onChanged: (value) => setState(() => _location = value),
                        decoration: InputDecoration(
                          hintText: 'Select or enter location',
                          hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5), fontFamily: 'Montserrat'),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: AppTheme.backgroundColor,
                          elevation: 10,
                          borderRadius: BorderRadius.circular(12),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    option,
                                    style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                                  ),
                                  onTap: () => onSelected(option),
                                  hoverColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Attendees
                  Text(
                    'ATTENDEES',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) => setState(() => _attendees = value),
                    decoration: InputDecoration(
                      hintText: 'e.g., Adv. Rajesh Pillai, Client Name',
                      hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5), fontFamily: 'Montserrat'),
                      filled: true,
                      fillColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // Link to Case (Optional)
                  Text(
                    'LINK TO CASE (OPTIONAL)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) => setState(() => _linkedCaseId = value),
                    decoration: InputDecoration(
                      hintText: 'Enter case ID or leave blank',
                      hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5), fontFamily: 'Montserrat'),
                      filled: true,
                      fillColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textPrimary,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _isFormValid() ? AppTheme.goldGradient : null,
                            color: _isFormValid() ? null : AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isFormValid() ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 12)] : [],
                          ),
                          child: ElevatedButton(
                            onPressed: _isFormValid() ? _submitEvent : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Add Event', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: _isFormValid() ? Colors.black : AppTheme.textSecondary)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ], // Closes inner Column children
              ), // Closes inner Column
            ), // Closes Padding
          ], // Closes outer Column children
        ), // Closes outer Column
      ), // Closes SingleChildScrollView
      ), // Closes Container
    ), // Closes BackdropFilter
  ), // Closes ClipRRect
); // Closes Dialog
  }
}
