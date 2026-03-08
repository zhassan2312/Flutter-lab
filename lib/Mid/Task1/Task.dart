import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepOrange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      theme: base.copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      ),
      darkTheme: base.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111315),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'Profile Page',
        onToggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  final String title;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('$label tapped'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final String modeLabel = widget.isDarkMode ? 'Night Theme' : 'Day Theme';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: widget.isDarkMode ? 0.20 : 0.12),
              colors.secondary.withValues(
                alpha: widget.isDarkMode ? 0.14 : 0.08,
              ),
              colors.tertiary.withValues(
                alpha: widget.isDarkMode ? 0.08 : 0.06,
              ),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Card(
                elevation: 10,
                shadowColor: colors.shadow.withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(
                            alpha: 0.55,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_moon_outlined,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              modeLabel,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.secondary],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 62,
                          backgroundImage: NetworkImage(
                            'https://avatars.githubusercontent.com/u/9919?s=280&v=4',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Zohaib Hassan',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'zhassan.ce44ceme@student.nust.edu.pk',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.work_outline, size: 18),
                            label: const Text('Flutter Learner'),
                            backgroundColor: colors.surfaceContainerHighest,
                            side: BorderSide(color: colors.outlineVariant),
                          ),
                          Chip(
                            avatar: const Icon(Icons.school_outlined, size: 18),
                            label: const Text('NUST Student'),
                            backgroundColor: colors.surfaceContainerHighest,
                            side: BorderSide(color: colors.outlineVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _showAction('Follow'),
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Follow'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _showAction('Message'),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('Message'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAction('Email'),
                            icon: const Icon(Icons.mail_outline),
                            label: const Text('Email'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Building consistent apps one widget at a time.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
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
