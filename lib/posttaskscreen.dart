//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostTaskPage extends StatefulWidget {
  const PostTaskPage({super.key});

  @override
  State<PostTaskPage> createState() => _PostTaskPageState();
}

class _PostTaskPageState extends State<PostTaskPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _descriptionController = TextEditingController();

  String? categoryValue;
  String? locationValue;
  bool isRemote = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFEEEBEB),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFEEEBEB),
            child: Center(
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF163a96)),
                          ),
                        ),
                        value: categoryValue,
                        onChanged: (newValue) {
                          setState(() {
                            categoryValue = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Laundry',
                            child: Text('Laundry'),
                          ),
                          DropdownMenuItem(
                            value: 'House Chores',
                            child: Text('House Chores'),
                          ),
                          DropdownMenuItem(
                            value: 'Garden Work',
                            child: Text('Garden Work'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter description',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF163a96)),
                            ),
                          )),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'location',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF163a96)),
                          ),
                        ),
                        value: locationValue,
                        onChanged: (newValue) {
                          setState(() {
                            locationValue = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Kampala',
                            child: Text('Kampala'),
                          ),
                          DropdownMenuItem(
                            value: 'Bukoto',
                            child: Text('Bukoto'),
                          ),
                          DropdownMenuItem(
                            value: 'Wakiso',
                            child: Text('Wakiso'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Text(
                            'Can this task be done remotely?',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Switch(
                              activeColor: const Color(0xFF163a96),
                              value: isRemote,
                              onChanged: (value) {
                                setState(() {
                                  isRemote = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF163a96), // Text Color background color)
                          ),
                          onPressed: _saveJobData,
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveJobData() async {
    final Map<String, dynamic> jobData = {
      'title': categoryValue,
      'description': _descriptionController.text,
      'location': locationValue,
      'isRemote': isRemote,
    };

    try {
      await _firestore.collection('jobs').add(jobData);
      // Job data saved successfully
      // You can navigate to the recommended jobs screen here or perform any other actions
    } catch (e) {
      // Error occurred while saving job data
      print('Error saving job data: $e');
    }
  }
}
