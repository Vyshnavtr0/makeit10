import 'package:flutter/material.dart';

class HowToPlayBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'How to Play Make It 10',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Objective:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Combine numbers to make 10 using allowed arithmetic operations',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Text(
            'Instructions:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '1. Drag arithmetic symbols ( +, - ) from the panel and drop them onto the board..',
            style: TextStyle(fontSize: 14.0),
          ),
          Text(
            '2. Swap numbers on the board to form combinations that sum up to 10.',
            style: TextStyle(fontSize: 14.0),
          ),
          // Text(
          //   '3. The combined numbers will disappear, and new numbers will drop from the top.',
          //   style: TextStyle(fontSize: 14.0),
          // ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Got It'),
          ),
        ],
      ),
    );
  }
}

class LevelWarningBottomSheet extends StatelessWidget {
  const LevelWarningBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Warning: Restricted Operations',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Red color for warning
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'This level restricts the use of certain operations, such as multiplication (×)',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Red color for warning
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Got it '),
          ),
        ],
      ),
    );
  }
}
