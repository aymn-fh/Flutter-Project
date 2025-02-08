import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyCustomAppState createState() => _MyCustomAppState();
}

class _MyCustomAppState extends State<MyApp> {
  ThemeMode currentTheme = ThemeMode.system;

  void switchTheme(bool isDark) {
    setState(() {
      currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: currentTheme,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent),
          ),
        ),
      ),
      home: HomePage(onThemeToggle: switchTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(bool) onThemeToggle;
  const HomePage({required this.onThemeToggle});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isDarkModeEnabled = false;
  bool isPasswordVisible = false;
  List<Map<String, String>> userData = [];

  void handleSubmit() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) return;

    setState(() {
      userData.add({"Username": usernameController.text, "Password": passwordController.text});
    });

    usernameController.clear();
    passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Submitted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aymen_Farhat App"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text("Dark Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
                widget.onThemeToggle(isDarkModeEnabled);
              },
              secondary: Icon(isDarkModeEnabled ? Icons.dark_mode : Icons.light_mode, color: Colors.teal),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person, color: Colors.teal),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.teal),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => UserDataPage(userData: userData),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // الحركة تبدأ من اليمين
                          const end = Offset.zero; // وتنتهي في مكانها الطبيعي
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text("View Data", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserDataPage extends StatelessWidget {
  final List<Map<String, String>> userData;
  const UserDataPage({required this.userData});

  Future<List<Map<String, String>>> fetchUserData() async {
    await Future.delayed(Duration(seconds: 2));
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          } else {
            final dataList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.teal),
                    title: Text("Username: ${dataList[index]['Username']}", style: TextStyle(color: Colors.black)),
                    subtitle: Text("Password: ${dataList[index]['Password']}", style: TextStyle(color: Colors.black54)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
