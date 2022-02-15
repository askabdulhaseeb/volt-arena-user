import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/consts/my_icons.dart';
import 'package:volt_arena/screens/search.dart';
import 'package:volt_arena/screens/search_person/search_person.dart';
import 'package:volt_arena/widget/tools/custom_drawer.dart';
import 'provider/bottom_navigation_bar_provider.dart';
import 'screens/servicesScreen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final List<Widget> pages = const <Widget>[
     ServicesScreen(),
     Search(),
    SearchPerson(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarProvider _page =
        Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: pages[_page.selectedPage],
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (int updatedPage) => _page.updateSelectedPage(updatedPage),
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade700,
          selectedItemColor: Colors.black,
          currentIndex: _page.selectedPage,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.room_service),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(MyAppIcons.search),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_search_outlined),
              label: 'Persons',
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  final List<IconData> _userTileIcons = <IconData>[
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title, Color color: Colors.yellow}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
      ),
    );
  }
}
