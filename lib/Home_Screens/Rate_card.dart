import 'dart:convert';
import 'package:http/http.dart' as http;

class _MyDrawerState extends State<MyDrawer> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final response = await http.get(Uri.parse('https://www.gurukulintl.com/eschoolplus/portal/api/mobileappmemenus?numStudentID=52655&apikey=3OZNsHgGOwcGZwtEVQ4bkopWc1bSc4kh'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        menuItems = jsonData.map((item) => MenuItem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load menu items');
    }
  }
}
class MenuItem {
  final String title;
  final String iconPath;
  final String route;

  MenuItem({required this.title, required this.iconPath, required this.route});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      iconPath: json['iconPath'],
      route: json['route'],
    );
  }
}

@override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: constants.backgroundColor,
    child: SafeArea(
      child: Column(
        children: [
          // Your existing profile code here...

          // Replace static DrawerMenu with dynamic menu items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return DrawerMenu(
                  title: item.title,
                  path: item.iconPath,
                  callback: () {
                    Navigator.pushNamed(context, item.route);
                  },
                  iconData: Icons.menu, // You can customize this based on your API response
                );
              },
            ),
          ),

          // Sign Out button and other static items...
        ],
      ),
    ),
  );
}


class MenuItem {
  final String title;
  final String iconPath;
  final String route;
  final String defaultIconPath; // New property for default icon

  MenuItem({
    required this.title,
    required this.iconPath,
    required this.route,
    required this.defaultIconPath, // Initialize the default icon
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      iconPath: json['iconPath'],
      route: json['route'],
      defaultIconPath: json['defaultIconPath'] ?? 'assets/icons/default_icon.png', // Provide a default if not present
    );
  }
}

class DrawerMenu extends StatelessWidget {
  final String title;
  final String? path;
  final String? subtitle;
  final String? tileColor;
  final IconData iconData;
  final Color? myColors;
  final Color? myIconColors;
  final VoidCallback? callback;
  final String defaultIconPath; // New property for default icon path

  DrawerMenu({
    super.key,
    required this.title,
    required this.iconData,
    this.subtitle,
    this.tileColor,
    this.myColors = Colors.black,
    this.myIconColors = Colors.black,
    this.callback,
    this.path,
    required this.defaultIconPath, // Initialize the default icon path
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (callback != null) {
          callback!();
        }
      },
      child: Container(
        height: 50,
        child: ListTile(
          tileColor: tileColor != null ? HexColor(tileColor!) : null,
          leading: path == null
              ? Icon(
                  iconData,
                  color: myIconColors,
                  size: 20,
                )
              : SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.network(
                    path!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      // Return the default icon if the image fails to load
                      return Image.asset(
                        defaultIconPath, // Use the default icon path
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
          title: MyTextSmall(
            title: title,
            color: myColors!,
          ),
        ),
      ),
    );
  }

  Expanded(
  child: ListView.builder(
    itemCount: menuItems.length,
    itemBuilder: (context, index) {
      final item = menuItems[index];
      return DrawerMenu(
        title: item.title,
        path: item.iconPath,
        defaultIconPath: item.defaultIconPath, // Pass the default icon path
        callback: () {
          Navigator.pushNamed(context, item.route); // Navigate to the route
        },
        iconData: Icons.menu, // You can customize this based on your API response
      );
    },
  ),
),
class DrawerMenu extends StatelessWidget {
  final String title;
  final String? path;
  final IconData iconData;
  final Color? myColors;
  final Color? myIconColors;
  final VoidCallback? callback;

  DrawerMenu({
    super.key,
    required this.title,
    required this.iconData,
    this.myColors = Colors.black,
    this.myIconColors = Colors.black,
    this.callback,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (callback != null) {
          callback!();
        }
      },
      child: Container(
        height: 50,
        child: ListTile(
          leading: path == null
              ? Icon(iconData, color: myIconColors, size: 20)
              : Image.network(
                  path!,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(iconData, color: myIconColors, size: 20); // Default icon
                  },
                ),
          title: Text(
            title,
            style: TextStyle(color: myColors),
          ),
        ),
      ),
    );
  }
} @override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: constants.backgroundColor,
    child: SafeArea(
      child: Column(
        children: [
          // Your existing profile code here...

          // Dynamic menu items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return DrawerMenu(
                  title: item.title,
                  iconData: Icons.help, // Default icon
                  path: item.iconPath, // Icon path from API
                  callback: () {
                    Navigator.pushNamed(context, item.route);
                  },
                );
              },
            ),
          ),

          // Sign Out button
          DrawerMenu(
            callback: () async {
              // Your sign-out logic here...
            },
            title: "Sign Out",
            iconData: Icons.backspace_outlined,
            myIconColors: Colors.red,
            myColors: Colors.red,
          ),
        ],
      ),
    ),
  );
}import 'dart:convert';
import 'package:http/http.dart' as http;
import 'menu_item_model.dart'; // Import the model

class _MyDrawerState extends State<MyDrawer> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final response = await http.get(Uri.parse('https://www.gurukulintl.com/eschoolplus/portal/api/mobileappmemenus?numStudentID=52655&apikey=3OZNsHgGOwcGZwtEVQ4bkopWc1bSc4kh'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        menuItems = jsonData.map((item) => MenuItem.fromJson(item)).toList();
      });
    } else {
      // Handle error
      print('Failed to load menu items');
    }
  }
}class MenuItem {
  final String title;
  final String route;
  final String? iconPath;

  MenuItem({required this.title, required this.route, this.iconPath});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      route: json['route'],
      iconPath: json['iconPath'],
    );
  }
}
