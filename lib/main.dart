// import 'package:flutter/material.dart';
// import 'package:monit/screens/data_screen.dart';
// import 'package:monit/screens/form.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: DefaultTabController(
//       initialIndex: 1,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Monitt'),
//           centerTitle: true,
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 text: 'Student Form',
//               ),
//               Tab(
//                 text: 'Registration',
//               ),
//               Tab(
//                 text: 'Monitoring',
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: <Widget>[
//             Center(
//               child: FormScreen(),
//             ),
//             Center(child: DataScreen()),
//             Center(
//               child: RetrieveScreen(),
//             ),
//           ],
//         ),

//         // Stack(
//         //   children: [
//         //     SizedBox(
//         //       height: 50,
//         //     ),
//         //     Container(
//         //       color: Colors.green,
//         //     ),
//         //     const Positioned(
//         //       top: 100, // Adjust the position of the card as needed
//         //       left: 20, // Adjust the position of the card as needed
//         //       right: 20, // Adjust the position of the card as needed
//         //       child: Card(
//         //         elevation: 10,
//         //         color: Colors.blue, // Set the desired color for the card
//         //         child: Padding(
//         //           padding: EdgeInsets.all(20.0),
//         //           child: Text(
//         //             'Hello, Card!',
//         //             style: TextStyle(
//         //               fontSize: 20,
//         //               fontWeight: FontWeight.bold,
//         //               color: Colors.white,
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       ),
//     ));
//   }
// }
//===================================Salar Code Starts Here=====================
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:monit/screens/data_screen.dart';
// import 'package:monit/screens/form.dart';

// String pass = '';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bluetooth Example',
//       home: BluetoothScreen(),
//     );
//   }
// }

// class BluetoothScreen extends StatefulWidget {
//   @override
//   _BluetoothScreenState createState() => _BluetoothScreenState();
// }

// class _BluetoothScreenState extends State<BluetoothScreen> {
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   BluetoothConnection? _connection;
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;
//   bool _isConnected = false;
//   String _message = '';

//   @override
//   void initState() {
//     super.initState();
//     _getDevices();
//   }

//   Future<void> _getDevices() async {
//     _devices = await _bluetooth.getBondedDevices();
//     setState(() {});
//   }

//   Future<void> _connectToDevice(BluetoothDevice device) async {
//     if (_connection != null) {
//       await _connection!.close();
//     }

//     try {
//       BluetoothConnection connection =
//           await BluetoothConnection.toAddress(device.address);
//       print('Connected to ${device.name}');
//       setState(() {
//         _connection = connection;
//         _selectedDevice = device;
//         _isConnected = true;
//       });
//       _receiveData();
//     } catch (error) {
//       print('Connection failed: $error');
//       setState(() {
//         _isConnected = false;
//       });
//     }
//   }

//   Future<void> _disconnect() async {
//     if (_connection != null) {
//       await _connection!.close();
//       setState(() {
//         _isConnected = false;
//         _selectedDevice = null;
//       });
//     }
//   }

//   void _sendMessage(String message) async {
//     if (_connection != null) {
//       List<int> messageBytes = utf8.encode(message);
//       _connection!.output.add(Uint8List.fromList(messageBytes));
//       await _connection!.output.allSent;
//       setState(() {
//         _message = message;
//       });
//     }
//   }

//   void _receiveData() {
//     List<int> buffer = []; // Buffer to accumulate incoming data

//     _connection!.input?.listen((List<int> data) {
//       buffer.addAll(data); // Add incoming data to the buffer

//       // Check if a complete message is received
//       if (buffer.contains(10)) {
//         // Assuming 10 is the delimiter character indicating the end of a message
//         String message = utf8.decode(buffer);
//         setState(() {
//           _message = message;
//           pass = _message;
//         });
//         buffer.clear(); // Clear the buffer for the next message
//       }
//     });
//   }

//   void _navigateToNextScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MyHomePage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Example'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MyHomePage()),
//               );
//             },
//             icon: Icon(Icons.navigate_next_sharp),
//           )
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text(
//               'Bluetooth Devices:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _devices.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_devices[index].name ?? ''),
//                     onTap: () {
//                       _connectToDevice(_devices[index]);
//                     },
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Selected Device: ${_selectedDevice?.name ?? 'None'}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             SizedBox(height: 8.0),
//             ElevatedButton(
//               child: Text(_isConnected ? 'Disconnect' : 'Connect'),
//               onPressed: _isConnected ? _disconnect : null,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Received Message:',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             SizedBox(height: 8.0),
//             Text(_message),
//             SizedBox(height: 16.0),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Send Message',
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _message = value;
//                 });
//               },
//             ),
//             SizedBox(height: 8.0),
//             ElevatedButton(
//               child: Text('Send'),
//               onPressed: _isConnected ? () => _sendMessage(_message) : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return (MaterialApp(
//         home: DefaultTabController(
//       initialIndex: 1,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Monitt'),
//           centerTitle: true,
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 text: 'Student Form',
//               ),
//               Tab(
//                 text: 'Registration',
//               ),
//               Tab(
//                 text: 'Monitoring',
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: <Widget>[
//             Center(
//               child: FormScreen(),
//             ),
//             Center(child: DataScreen()),
//             Center(
//               child: RetrieveScreen(),
//             ),
//           ],
//         ),
//       ),
//     )));
//   }
// }
//===================================Salar Code Ends Here=====================

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:monit/screens/data_screen.dart';
import 'package:monit/screens/form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/database_helper.dart';

String pass = '';
List<int> imageBytes = []; // Variable to store received image bytes

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Example',
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _isConnected = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  Future<void> _getDevices() async {
    _devices = await _bluetooth.getBondedDevices();
    setState(() {});
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_connection != null) {
      await _connection!.close();
    }

    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      print('Connected to ${device.name}');
      setState(() {
        _connection = connection;
        _selectedDevice = device;
        _isConnected = true;
      });
      _receiveData();
    } catch (error) {
      print('Connection failed: $error');
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> _disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      setState(() {
        _isConnected = false;
        _selectedDevice = null;
      });
    }
  }

  void _sendMessage(String message) async {
    if (_connection != null) {
      List<int> messageBytes = utf8.encode(message);
      _connection!.output.add(Uint8List.fromList(messageBytes));
      await _connection!.output.allSent;
      setState(() {
        _message = message;
      });
    }
  }

  void _receiveData() {
    List<int> buffer = []; // Buffer to accumulate incoming data

    _connection!.input?.listen((List<int> data) {
      buffer.addAll(data); // Add incoming data to the buffer

      // Check if a complete message is received
      if (buffer.contains(10)) {
        // Assuming 10 is the delimiter character indicating the end of a message
        String message = utf8.decode(buffer);
        setState(() {
          _message = message;
          pass = _message;
        });

        // Check if the received data is an image
        if (message.startsWith("IMAGE:")) {
          // Extract the image data
          String imageDataString = message.substring(6);

          try {
            imageBytes = base64.decode(imageDataString);
          } catch (e) {
            print('Error decoding image data: $e');
            imageBytes = [];
          }

          // Clear the buffer for the next message
          buffer.clear();

          // Display the received image
          setState(() {});
        } else {
          buffer.clear(); // Clear the buffer for the next message
        }
      }
    });
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Example'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            icon: Icon(Icons.navigate_next_sharp),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Bluetooth Devices:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_devices[index].name ?? ''),
                    onTap: () {
                      _connectToDevice(_devices[index]);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Selected Device: ${_selectedDevice?.name ?? 'None'}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text(_isConnected ? 'Disconnect' : 'Connect'),
              onPressed: _isConnected ? _disconnect : null,
            ),
            SizedBox(height: 16.0),
            Text(
              'Received Message:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(_message),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Send Message',
              ),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('Send'),
              onPressed: _isConnected ? () => _sendMessage(_message) : null,
            ),
            SizedBox(height: 16.0),
            Text(
              'Received Image:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Container(
                child: imageBytes.isNotEmpty
                    ? Image.memory(Uint8List.fromList(imageBytes))
                    : Text('No image received'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (MaterialApp(
        home: DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitt'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // Sync();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Student Form',
              ),
              Tab(
                text: 'Registration',
              ),
              Tab(
                text: 'Monitoring',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: FormScreen(),
            ),
            Center(child: DataScreen()),
            Center(
              child: RetrieveScreen(),
            ),
          ],
        ),
      ),
    )));
  }
}

// Future<void> initializeFirebase() async {
//   await Firebase.initializeApp();
// }

// Future<void> Sync() async {
//   try {
//     // Initialize Firebase
//     await initializeFirebase();

//     // Access your local database using _databaseHelper instance
//     List<Map<String, dynamic>> localData = await DatabaseHelper.getStudents();

//     // Connect to Firebase Firestore
//     FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Iterate through the local data and send it to Firebase
//     for (var student in localData) {
//       // Add a new document to the "students" collection with the local data
//       await firestore.collection('students').add(student);

//       // Update the synced value to 1 in your local database
//       student['sync'] = 1;
//       await DatabaseHelper.updateStudent(student);
//     }

//     print('Data synchronization complete!');
//   } catch (e) {
//     print('Data synchronization failed: $e');
//   }
// }
