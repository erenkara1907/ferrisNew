import 'package:flutter/material.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({Key? key}) : super(key: key);

  @override
  State<TabbedPage> createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabbed Page'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Today'),
              const Tab(text: 'Tomorrow'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Today Button'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //TODO ProductStateItems.hiveDatabaseManager.clearUserModel();
                },
                child: const Text('Tomorrow Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
