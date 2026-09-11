import 'package:flutter/material.dart';

class CaseStage {
  final int step;
  final String name;
  final String description;

  const CaseStage({
    required this.step,
    required this.name,
    required this.description,
  });
}

/// Static data for case workflow stages
class CaseStages {
  static const List<CaseStage> stages = [
    CaseStage(step: 0, name: 'Consultation', description: 'Initial client meeting and conflict check'),
    CaseStage(step: 1, name: 'Doc Collection', description: 'Gathering documents and legal research'),
    CaseStage(step: 2, name: 'Drafting', description: 'Preparing plaint/petition and review'),
    CaseStage(step: 3, name: 'Filing', description: 'Filing in court and clearing defects'),
    CaseStage(step: 4, name: 'Admission', description: 'Case admission and issuing notice'),
    CaseStage(step: 5, name: 'Pleadings', description: 'Filing written statement/replies/rejoinder'),
    CaseStage(step: 6, name: 'Issues', description: 'Court frames the legal issues/charges'),
    CaseStage(step: 7, name: 'Evidence', description: 'Filing affidavits and cross-examination'),
    CaseStage(step: 8, name: 'Arguments', description: 'Oral arguments presentation'),
    CaseStage(step: 9, name: 'Judgment', description: 'Judgment delivered and orders passed'),
    CaseStage(step: 10, name: 'Billing', description: 'Generate and settle invoices'),
    CaseStage(step: 11, name: 'Closed', description: 'Execution, appeal, and case closure'),
  ];

  static CaseStage getStage(int step) {
    if (step >= 0 && step < stages.length) {
      return stages[step];
    }
    return stages[0];
  }

  static String getStageName(int step) => getStage(step).name;
  static String getStageDescription(int step) => getStage(step).description;
}

/// Widget to display case stages as a timeline/progress indicator
class CaseStagesWidget extends StatelessWidget {
  final int currentStep;
  final Function(int)? onStepTapped;
  final bool isEditable;
  final Map<int, String>? stageRemarks;

  const CaseStagesWidget({
    Key? key,
    required this.currentStep,
    this.onStepTapped,
    this.isEditable = false,
    this.stageRemarks,
  }) : super(key: key);

  Color _getStepColor(int index) {
    if (index < currentStep) return Colors.green;
    if (index == currentStep) return Colors.blue;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          CaseStages.stages.length,
          (index) {
            final stage = CaseStages.stages[index];
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            final isLast = index == CaseStages.stages.length - 1;

            return Row(
              children: [
                GestureDetector(
                  onTap: isEditable ? () => onStepTapped?.call(index) : null,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStepColor(index),
                          border: isCurrent
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text(
                              stage.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                color: isCurrent ? Colors.blue : Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (stageRemarks != null && stageRemarks![index] != null && stageRemarks![index]!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(Icons.speaker_notes, size: 12, color: Colors.blueGrey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 30,
                    height: 3,
                    margin: EdgeInsets.only(top: 12, bottom: 28),
                    color: index < currentStep ? Colors.green : Colors.grey.shade300,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Compact vertical version of case stages
class CompactCaseStagesWidget extends StatelessWidget {
  final int currentStep;
  final bool showDescription;

  const CompactCaseStagesWidget({
    Key? key,
    required this.currentStep,
    this.showDescription = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentStage = CaseStages.getStage(currentStep);
    final progress = (currentStep + 1) / CaseStages.stages.length;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Case Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${currentStep + 1}/${CaseStages.stages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 12),
            Text(
              currentStage.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showDescription)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  currentStage.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Detailed case stages info widget with all stages listed
class DetailedCaseStagesWidget extends StatelessWidget {
  final int currentStep;
  final Function(int)? onStepTapped;

  const DetailedCaseStagesWidget({
    Key? key,
    required this.currentStep,
    this.onStepTapped,
  }) : super(key: key);

  Color _getStageColor(int index) {
    if (index < currentStep) return Colors.green;
    if (index == currentStep) return Colors.blue;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: CaseStages.stages.length,
      itemBuilder: (context, index) {
        final stage = CaseStages.stages[index];
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStageColor(index),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          title: Text(
            stage.name,
            style: TextStyle(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? Colors.blue : Colors.black,
            ),
          ),
          subtitle: Text(stage.description),
          trailing: isCurrent
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
