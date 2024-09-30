import 'package:custom_otp_modal/custom_otp_modal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Modal Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<void> showOtp(BuildContext context) async {
    OtpModal otpModal = OtpModal(
      context: context,
      keyboardType: TextInputType.number,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      buttonColor: Colors.white,
      borderColor: Colors.blue,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      buttonTextStyle: const TextStyle(color: Colors.blue, fontSize: 16),
      otpTtl: 60, // OTP TTL in seconds
    );

    String? otpValue = await otpModal.show();
    if (otpValue != null && otpValue == "123456") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verification Failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Modal Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showOtp(context);
          },
          child: const Text('Show OTP Modal'),
        ),
      ),
    );
  }
}
