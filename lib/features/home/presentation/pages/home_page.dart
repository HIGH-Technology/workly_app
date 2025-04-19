import 'package:flutter/material.dart';
import 'package:workly_flutter/core/theme/app_theme.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardScreen(),
    const _EmployeesScreen(),
    const _SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getInitials() {
    if (widget.user.name.isEmpty) {
      return 'U';
    }
    return widget.user.name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workly'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implementar notificações
            },
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 16,
            child: Text(
              _getInitials(),
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Funcionários',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  context,
                  title: 'Funcionários',
                  value: '24',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Departamentos',
                  value: '5',
                  icon: Icons.business,
                  color: Colors.orange,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Tarefas',
                  value: '12',
                  icon: Icons.assignment,
                  color: Colors.green,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Projetos',
                  value: '8',
                  icon: Icons.work,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeesScreen extends StatelessWidget {
  const _EmployeesScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Funcionários',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implementar adição de funcionário
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      'F${index + 1}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Funcionário ${index + 1}'),
                  subtitle: Text('Departamento ${(index % 5) + 1}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Implementar opções do funcionário
                    },
                  ),
                  onTap: () {
                    // Implementar visualização de detalhes do funcionário
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildSettingItem(
                  context,
                  title: 'Perfil',
                  icon: Icons.person_outline,
                  onTap: () {
                    // Implementar perfil
                  },
                ),
                _buildSettingItem(
                  context,
                  title: 'Notificações',
                  icon: Icons.notifications_outlined,
                  onTap: () {
                    // Implementar notificações
                  },
                ),
                _buildSettingItem(
                  context,
                  title: 'Segurança',
                  icon: Icons.security_outlined,
                  onTap: () {
                    // Implementar segurança
                  },
                ),
                _buildSettingItem(
                  context,
                  title: 'Aparência',
                  icon: Icons.color_lens_outlined,
                  onTap: () {
                    // Implementar aparência
                  },
                ),
                _buildSettingItem(
                  context,
                  title: 'Idioma',
                  icon: Icons.language_outlined,
                  onTap: () {
                    // Implementar idioma
                  },
                ),
                _buildSettingItem(
                  context,
                  title: 'Sair',
                  icon: Icons.logout_outlined,
                  onTap: () {
                    // Implementar logout
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
