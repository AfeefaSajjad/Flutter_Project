import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../resources/colors.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                task['task'],
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Description: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Text(
                task['description'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textColor,
                ),
              ),
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1.5,
              indent: screenWidth * 0.15,
              endIndent: screenWidth * 0.15,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Status:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
                color: AppColors.textColor,
              ),
            ),
            Center(
              child: Text(
                task['isCompleted'] ? 'Completed' : 'Pending',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            Divider(
              color: AppColors.borderColor,
              thickness: 1.5,
              indent: screenWidth * 0.15,
              endIndent: screenWidth * 0.15,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Added On:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
              ),
            ),
            Center(
              child: Text(
                DateFormat('MMM dd, yyyy - hh:mm a')
                    .format(DateTime.parse(task['timeAdded'])),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
