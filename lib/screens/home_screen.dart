import 'package:flutter/material.dart';
import 'package:todo_app_with_shared_preference/screens/login_screen.dart';

import '../resources/colors.dart';
import 'list_screen.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const ListScreen(),
    const ProfileScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double fontSize = width * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quick Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primaryColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.08, left: 20),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/3.jpg',
                  width: width * 0.22,
                  height: width * 0.22,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text("Flutter Service",
                style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: height * 0.01,
            ),
            Text("Flutterservice@gmail.com",
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: fontSize,
                )),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.06,
              width: width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.backgroundColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2.0,
                    blurRadius: 2.0,
                    offset: const Offset(2.0, 2.0),
                  )
                ],
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: Text("Sign Out",
                      style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: fontSize * 1.4,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.08),
                child: ListView(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.person,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("Profile",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.dashboard_sharp,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("Dashboard",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.home,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("Home",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const Divider(
                      color: AppColors.backgroundColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.01, left: 17),
                      child: Text("Communicate",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: fontSize * 1.2,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.lock,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("Privacy Policy",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("Contact us ",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.memory_rounded,
                        color: AppColors.backgroundColor,
                      ),
                      title: Text("About App",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 15,
                          )),
                    ),
                    const Divider(
                      color: AppColors.backgroundColor,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Center(
                      child: Text("Develop By",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: fontSize * 1.3,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.001,
                    ),
                    Center(
                      child: Text("Flutter Service",
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: fontSize * 1.2,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textColor,
        backgroundColor: AppColors.backgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task_alt,
              color: AppColors.primaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: AppColors.primaryColor,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: AppColors.primaryColor,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
