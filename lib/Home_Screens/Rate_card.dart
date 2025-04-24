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
