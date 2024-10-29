import 'package:fcm_shared_isolate/fcm_shared_isolate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FcmSharedIsolate _firebase = FcmSharedIsolate();

  String? _message;
  String? _token;
  bool? _isPermissionGranted;

  @override
  void initState() {
    super.initState();
    _firebase.setListeners(
      onNewToken: (final String token) {
        debugPrint('Got a new Firebase token: $token');
        setState(() {
          _token = token;
        });
      },
      onMessage: (final Map<dynamic, dynamic> message) {
        debugPrint('Got a new Firebase message: $message');
        setState(() {
          _message = message.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('fcm_shared_isolate example app'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Message: $_message',
              ),
              Text(
                'Token: $_token',
              ),
              Text(
                'Permission granted: $_isPermissionGranted',
              ),
              ElevatedButton(
                onPressed: () async {
                  String? token;
                  try {
                    token = await _firebase.getToken();
                    debugPrint('Firebase token: $token');
                  } catch (e, stacktrace) {
                    final String error = e.toString();
                    debugPrintStack(
                      stackTrace: stacktrace,
                      label: error,
                    );
                    token = error;
                  }
                  setState(() {
                    _token = token;
                  });
                },
                child: Text('Get token'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bool isPermissionGranted =
                      await _firebase.requestPermission();
                  debugPrint('isPermissionGranted: $isPermissionGranted');
                  setState(() {
                    _isPermissionGranted = isPermissionGranted;
                  });
                },
                child: Text('Request permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
