import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:googleapis_auth/auth_io.dart' as auth;

class SendNotifications extends StatefulWidget {
  const SendNotifications({super.key});

  @override
  State<SendNotifications> createState() => _SendNotificationsState();
}

class _SendNotificationsState extends State<SendNotifications> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  final String _serviceAccountJson = json.encode({
        // service account json should be added
      
  });

 Future<void> _sendPushNotification(String title, String message) async {
  final List<String> scopes = [
    
  ];

  try {
    // Load service account credentials
    final credentials = auth.ServiceAccountCredentials.fromJson(
        json.decode(_serviceAccountJson));

    // Obtain an OAuth2 client
    final authClient = await auth.clientViaServiceAccount(credentials, scopes);

    // The specific token to send notification
    const String targetToken =
        "fExUPa5KTbOPIfUrvld_OA:APA91bGKftC-rQM7QcrMfJqzRJ0XkHT8UOaXZ4orRQpQRzAUtCYuU8Hq2b7-VWn9nZve6Uvd0qZQxHrBH8t9uWSbEHtTN9Oo2FaZVQYn1V0hsiF-MmKcKrU";

    // Construct the notification payload
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/ambulance-service-ebccd/messages:send');

    final response = await authClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'message': {
          'token': targetToken,
          'notification': {
            'title': title,
            'body': message,
          },
        },
      }),
    );

    // Log response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Notification Sent!')));
      // Clear text fields after sending notification
      //kjdsfkajhdk fkjasdfljk git
      //kjhdsafkjklasdjf
      _titleController.clear();
      _messageController.clear();
    } else {
      print('Failed to send notification: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification')));
    }

    authClient.close();
  } catch (e) {
    // Log any errors
    print('Error sending notification: $e');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending notifications: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Notification Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Notification Message'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendPushNotification(
                      _titleController.text,
                      _messageController.text,
                    );
                  }
                },
                child: Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}