  Future<void> checkAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthEnabled = prefs.getBool('isAuth') ?? false;

    final bool canAuthWithBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    print('Available biometrics: $availableBiometrics');
    print('Can authenticate with biometrics: $canAuthWithBiometrics');

    if (!canAuthWithBiometrics) {
      print('Biometrics not available');
      SystemNavigator.pop();
      return;
    }

    if (isAuthEnabled) {
      authenticateUser ();
    } else {
      checkIsLogin();
    }
  }  

Future<void> authenticateUser() async {
    try {
      print('auth false');
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        checkIsLogin();
      } else {
          SystemNavigator.pop();
          if (!isAuthDialogShown) {
            isAuthDialogShown = true;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: MyTextSmall(title: 'Authentication Failed',fontWeight: FontWeight.bold,),
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
                          authenticateUser ();
                        },
                        child: MyTextMini(title: 'Retry',color: Colors.white,),
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
                        child: MyTextMini(title: 'Exit',color: Colors.white,),
                      ),
                    ),
                  ],
                );
              },
            );
          }
      }
    } catch (e) {
      print('Error during authentication: $e');
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const LogInScreen()));
    }

Error during authentication: PlatformException(NotAvailable, Security credentials not available., null, null)
clear shared preference
then called Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogInScreen()));
