import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'random_recipe_tab.dart';
import 'recipe_management_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 初始化数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('菜谱大全'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.restaurant_menu),
                text: '随机推荐',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: '菜谱管理',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RandomRecipeTab(),
            RecipeManagementTab(),
          ],
        ),
      ),
    );
  }
}