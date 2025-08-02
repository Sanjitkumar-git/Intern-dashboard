import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
  BlocProvider(
    create: (_) => LoginCubit(),
    child: const MyApp(),
  ),
);

class LoginCubit extends Cubit<String> {
  LoginCubit() : super("");

  void login(String name) {
    emit(name.isEmpty ? "Intern" : name);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intern Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (nameController.text.isNotEmpty) {
      context.read<LoginCubit>().login(nameController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Intern Login", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Enter Your Name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text("Login", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                          onPressed: _login,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Sign Up", style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final Map<String, dynamic> mockData = {
  'totalDonations': 5000,
  'rewards': ["Bronze Badge", "Silver Badge", "Gold Badge"],
  'leaderboard': [
    {'name': 'Mohit', 'donations': 10000},
    {'name': 'Raja', 'donations': 8000},
    {'name': 'Sanjit', 'donations': 6000},
    {'name': 'Ricky', 'donations': 4000},
    {'name': 'Bahadur', 'donations': 2000},
  ],
  'announcements': [
    'New fundraising campaign starts next week!',
    'Top performers will receive exclusive merchandise.',
    'Check your referral code and share it!',
  ],
};

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String internName = context.watch<LoginCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[700]),
              child: Text("Menu", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.blue[700]),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.leaderboard, color: Colors.blue[700]),
              title: const Text('Leaderboard'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage())),
            ),
            ListTile(
              leading: Icon(Icons.announcement, color: Colors.blue[700]),
              title: const Text('Announcements'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsPage())),
            ),
          ],
        ),
      ),
      body: DashboardContent(internName: internName),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final String internName;
  const DashboardContent({super.key, required this.internName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: Text("Welcome, $internName!", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[700])),
        ),
        const SizedBox(height: 10),
        Text("Referral Code: ${internName.toLowerCase()}2025", style: GoogleFonts.robotoMono(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 10),
        Text("Total Donations Raised: ₹${mockData['totalDonations']}", style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 20),
        Text("Rewards / Unlockables:", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700])),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: (mockData['rewards'] as List<String>)
              .map((r) => Chip(label: Text(r, style: GoogleFonts.poppins(color: Colors.white)), backgroundColor: Colors.blue))
              .toList(),
        ),
      ]),
    );
  }
}


class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = mockData['leaderboard'] as List;

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue[700]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final user = leaderboard[index];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.blue[700], child: Text('${index + 1}', style: const TextStyle(color: Colors.white))),
              title: Text(user['name'], style: GoogleFonts.poppins(fontSize: 16)),
              trailing: Text('₹${user['donations']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }
}


class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = mockData['announcements'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: const Text('Announcements', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue[700]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(padding: const EdgeInsets.all(16), child: Text(announcements[index], style: GoogleFonts.poppins(fontSize: 16))),
          );
        },
      ),
    );
  }
}
