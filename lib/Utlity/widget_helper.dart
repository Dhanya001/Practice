onPressed: () async {
  if (_formKey.currentState?.validate() ?? false) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Phone', _phoneController.text);
    
    bool isInternetConnected = await constant.isInternet();
    if (isInternetConnected) {
      constant.showLoading(context);
      try {
        if (_userEmail != null) {
          var response = await GlobalHelper().login(
            _phoneController.text.trim(),
            _userEmail!,
          );

          if (response != null && response['success'] == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OtpScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed. Please try again.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please Sign in E-mail")),
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        });
      }
    } else {
      constant.showErrorDialog(
        context,
        'Internet Error!',
        'Please check your internet connection',
        icon: Icon(
          Icons.wifi_off_rounded,
          color: Colors.black38,
        ),
      );
    }
  }
}


SendOTP(String otp) async {
    print('Sending : otp=$otp,');
    try {
      var response = await http.post(
        Uri.parse('${constant.apiLocalName}/verifyOtp'),
		 headers: {
    'Content-Type': 'application/json', // Specify the content type
  },
        body: {
          'otp': otp,
        },
      );
      print('resoponse: ${response}');
      print('status: ${response.statusCode}');
      print('body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('data: $responseData');
      } else {
        print('error: ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception(': ${response.statusCode}');
      }
    }catch(e){
      print('Error during Otp authentication: $e');
      rethrow;
    }
  }


Future<void> _sendOtpToEmail(String? email) async {
    final int otp = 100000 + Random().nextInt(900000); // Generate a 6-digit OTP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('otp', otp); // Store OTP as an int
    await prefs.setString('userEmail', email!);

    print('Sending OTP: $otp to $email');
}

Future<void> _loadPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        _phoneNumber = prefs.getString('Phone');
        // Retrieve OTP as an int
        int? otp = prefs.getInt('otp');
        print('Loaded OTP: $otp'); // Debug print
    });
}

SendOTP(int otp) async {
    print('Sending : otp=$otp,');
    try {
        var response = await http.post(
            Uri.parse('${constant.apiLocalName}/verifyOtp'),
            headers: {
                'Content-Type': 'application/json', // Specify the content type
            },
            body: jsonEncode({'otp': otp.toString()}), // Convert OTP to string for JSON
        );
        print('response: ${response}');
        print('status: ${response.statusCode}');
        print('body: ${response.body}');

        if (response.statusCode == 200) {
            var responseData = jsonDecode(response.body);
            print('data: $responseData');
        } else {
            print('error: ${response.reasonPhrase}');
            print('Response body: ${response.body}');
            throw Exception(': ${response.statusCode}');
        }
    } catch (e) {
        print('Error during Otp authentication: $e');
        rethrow;
    }
}

SizedBox(
    width: double.infinity,
    child: MyBottomButton(
        title: "Continue",
        onPressed: () async {
            bool isInternetConnected = await constant.isInternet();
            if (isInternetConnected) {
                try {
                    int otp = int.parse(_otpController.text); // Convert input to int
                    var response = await GlobalHelper().SendOTP(otp); // Send OTP as int
                    if (response != null && response['success'] == true) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AllowLocationPage()),
                        );
                    } else {
                        setState(() {
                            _invalidOtp = true;
                        });
                    }
                } catch (e) {
                    setState(() {
                        _invalidOtp = true; // Show invalid OTP message
                    });
                }
            } else {
                constant.showErrorDialog(context, 'Internet Error!',
                    'Please check your internet connection',
                    icon: Icon(
                        Icons.wifi_off_rounded,
                        color: Colors.black38,
                    ));
            }
        },
    ),
),
