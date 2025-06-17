Future<void> checkAuth() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isAuthEnabled = prefs.getBool('isAuth') ?? false;

  final bool isDeviceSupported = await auth.isDeviceSupported();
  final bool canAuthWithBiometrics = await auth.canCheckBiometrics;

  print('Device supported: $isDeviceSupported');
  print('Can authenticate with biometrics: $canAuthWithBiometrics');

  if (!isDeviceSupported || !canAuthWithBiometrics) {
    print('Biometrics not available or supported');
    // Clear auth preference if needed
    await prefs.remove('isAuth');

    // Redirect to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LogInScreen()),
    );
    return;
  }

  if (isAuthEnabled) {
    authenticateUser();
  } else {
    checkIsLogin();
  }
}
Future<void> authenticateUser() async {
  try {
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to access the app',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );

    if (didAuthenticate) {
      checkIsLogin();
    } else {
      showFailedDialog();
    }
  } on PlatformException catch (e) {
    print('Error during authentication: $e');

    if (e.code == 'NotAvailable') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isAuth');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogInScreen()),
      );
    } else {
      showFailedDialog();
    }
  }
}
void showFailedDialog() {
  if (!isAuthDialogShown) {
    isAuthDialogShown = true;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: MyTextSmall(title: 'Authentication Failed', fontWeight: FontWeight.bold),
          content: MyTextMini(title: 'Please try again.'),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  isAuthDialogShown = false;
                  Navigator.of(context).pop();
                  authenticateUser();
                },
                child: MyTextMini(title: 'Retry', color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  isAuthDialogShown = false;
                  SystemNavigator.pop();
                },
                child: MyTextMini(title: 'Exit', color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
