import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'Allow_location_Page.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _invalidOtp = false;
  int _resendTime = 60;
  late Timer _countdownTimer;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _resendTime--;
      });
      if (_resendTime < 1) {
        _countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.width * 0.12,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _resendTime > 0
                  ? "Resend OTP in $_resendTime seconds"
                  : "Didn't receive the code?",
            ),
            if (_resendTime == 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _resendTime = 60;
                  });
                  _startTimer();
                },
                child: const Text("Resend"),
              ),
            const SizedBox(height: 20),
            Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: defaultPinTheme,
              onChanged: (value) {
                setState(() {
                  _invalidOtp = false;
                });
              },
            ),
            if (_invalidOtp)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Invalid OTP!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final otp = _otpController.text.trim();
                  if (otp.length < 6) {
                    setState(() {
                      _invalidOtp = true;
                    });
                    return;
                  }
                  try {
                    final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: otp,
                    );
                    await FirebaseAuth.instance.signInWithCredential(credential);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllowLocationPage()),
                    );
                  } catch (e) {
                    setState(() {
                      _invalidOtp = true;
                    });
                  }
                },
                child: const Text(
                  "Verify & Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'OTP_Screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Sign in with your phone number"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+91 ",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  } else if (!RegExp(r"^[6-9]\d{9}$").hasMatch(value)) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+91${_phoneController.text}",
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message ?? "Error")),
                            );
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtpScreen(verificationId: verificationId),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  child: const Text("Send OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SingleChildScrollView(
  child: Column(
    children: [
      // Existing widgets...

      //Ticket Section
      SizedBox(height: 10,),
      Container(
        height: 300, // Set a fixed height or use MediaQuery to make it responsive
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: scheduledPickups.length,
            itemBuilder: (context, index) {
              final pickup = scheduledPickups[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey,
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${formatDate(pickup['date'])}'),
                            Gap(5),
                            Text('${pickup['slot']}'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Wrap(
                            children: (pickup['items'] as List).map((item) =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:4.0),
                                  child: Chip(
                                    label: Text(item),
                                    backgroundColor: Color(0xffDBEAE3),
                                  ),
                                ),
                            ).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                      },
                                      child: MySmallText(title: 'Reschedule',color:Colors.white,),
                                    ),
                                  ),
                                  Gap(15),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                      },
                                      child: Text('Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // Other widgets...
    ],
  ),
),
