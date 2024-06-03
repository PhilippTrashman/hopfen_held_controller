import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hopfen_held/utils/bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';

import 'items/custom_joystick_area.dart';
import 'items/spritzer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demokraten',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemokratenApp(),
    );
  }
}

class DemokratenApp extends StatefulWidget {
  const DemokratenApp({super.key});

  @override
  State<DemokratenApp> createState() => _DemokratenAppState();
}

class _DemokratenAppState extends State<DemokratenApp> {
  String bluetoothStatus = 'Connect';
  BluetoothConnection? bluetoothConnection;
  InputHandler inputHandler = InputHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BodyLayout(
        inputHandler: inputHandler,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Demokratie bringer",
          style: TextStyle(fontSize: 20, color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 51, 107, 56),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20)),
          onPressed: () {
            if (bluetoothConnection != null &&
                bluetoothConnection!.isConnected) {
              disconnect();
            } else {
              handleConnectRequest();
            }
          },
          child: Row(
            children: [
              Text(bluetoothStatus),
              const Icon(Icons.bluetooth),
            ],
          ),
        ),
      ],
    );
  }

  Future handleConnectRequest() async {
    await Permission.bluetoothScan.status.then((value) async {
      debugPrint("-------!${value.isGranted}!-------");
      if (value.isGranted) {
        debugPrint('Bluetooth permission granted');
        connectAndSendCommands(inputHandler);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Bluetooth Permission'),
                content: const Text(
                    'This app requires bluetooth permission to connect to the device, please allow location and nearby devices permission to continue.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await openAppSettings().then((value) async {
                        Navigator.of(context).pop();
                        await Permission.bluetoothScan.status.then((value) {
                          debugPrint("-------!${value.isGranted}!-------");
                          if (value.isGranted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Bluetooth permission granted, please try again.')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Bluetooth permission is required to connect to the device.')));
                          }
                        });
                      });
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            });
      }
    });
  }

  Future<void> connectAndSendCommands(InputHandler inputHandler) async {
    setState(() {
      bluetoothStatus = 'Connecting';
    });
    // Initialize Bluetooth
    FlutterBluetoothSerial flutterBluetoothSerial =
        FlutterBluetoothSerial.instance;
    // Start scanning for devices
    flutterBluetoothSerial.startDiscovery().listen((r) {
      BluetoothDiscoveryResult result = r;
      debugPrint(result.device.name);
      if (result.device.name == 'Leopard') {
        // Connect to ESP32
        BluetoothConnection.toAddress(result.device.address).then((connection) {
          debugPrint('Connected!');
          setState(() {
            bluetoothStatus = 'Connected!';
          });
          _startSendingCommands(connection, inputHandler);
        }).catchError((error) {
          debugPrint('Failed to connect: $error');
          setState(() {
            bluetoothStatus = 'Connect';
          });
        });
      }
    });
  }

  void _startSendingCommands(
      BluetoothConnection connection, InputHandler inputHandler) {
    bluetoothConnection = connection;
    bool canSend = true;

    connection.input?.listen((Uint8List data) {
      String response = utf8.decode(data);
      if (response.trim() == 'OK') {
        canSend = true;
      }
    }, onDone: () {
      debugPrint('Connection closed!');
      setState(() {
        bluetoothStatus = 'Connect';
      });
    }, onError: (error) {
      debugPrint('Error: $error');
      setState(() {
        bluetoothStatus = 'Connect';
      });
    });

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (canSend) {
        canSend = false;
        Map data = {
          'xValue': inputHandler.getJoystickData()[0],
          'yValue': inputHandler.getJoystickData()[1]
        };
        connection.output.add(utf8.encode(''
            '${inputHandler.getJoystickData()[0]};'
            '${inputHandler.getJoystickData()[1]};'
            '${inputHandler.getLadderPosition()};'
            '${inputHandler.getWaterPumpState()};'
            '${inputHandler.getIndicatorState()};'
            '${inputHandler.getLightState()};'
            '${inputHandler.getAutopilotState()}'
            '\n'));
      }
    });
  }

  void disconnect() {
    if (bluetoothConnection != null && bluetoothConnection!.isConnected) {
      bluetoothConnection!.dispose();
      bluetoothConnection = null;
      setState(() {
        bluetoothStatus = 'Connect';
      });
    }
  }
}

class BodyLayout extends StatelessWidget {
  final InputHandler inputHandler;

  const BodyLayout({Key? key, required this.inputHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    CustomJoystickArea joystick = CustomJoystickArea(
        inputHandler: inputHandler); // Übergabe der Instanz von InputHandler
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/bundeswehr.jpg',
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: joystick,
                ),
                Spacer(),
                Expanded(
                  flex: 4,
                  child: spritzerExpanded(screenHeight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
