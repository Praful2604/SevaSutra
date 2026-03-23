import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/user.dart';
import 'package:sevasutra_flutter/screens/drawer_button/common_drawer.dart';

class ReportPage extends StatefulWidget {
  final String userEmail;
  final String userName;

  const ReportPage({
    super.key,
    required this.userEmail,
     required this.userName,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int syncedCount = 0;
  int unsyncedCount = 0;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    loadReportData();

    // ✅ REAL-TIME AUTO UPDATE
    final isar = Isar.getInstance()!;
    isar.users.watchLazy().listen((_) {
      loadReportData();
    });
  }

  // ✅ LOAD DATA BASED ON EMAIL
  Future<void> loadReportData() async {
    final isar = Isar.getInstance()!;

    final allData =
        await isar.users.filter().userEmailEqualTo(widget.userEmail).findAll();

    final syncedData = await isar.users
        .filter()
        .userEmailEqualTo(widget.userEmail)
        .and()
        .isSyncedEqualTo(true)
        .findAll();

    setState(() {
      totalCount = allData.length;
      syncedCount = syncedData.length;
      unsyncedCount = totalCount - syncedCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey),
        ),
      ),
      drawer: CommonDrawer(
        userName: widget.userName ?? "Guest",
        userEmail: widget.userEmail ?? "No Email",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 📊 BAR GRAPH
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (totalCount + 5).toDouble(),
                  barTouchData: BarTouchData(enabled: true),
                  borderData: FlBorderData(show: false),

                  /// ✅ AXIS TITLES
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Synced");
                            case 1:
                              return const Text("Unsynced");
                            case 2:
                              return const Text("Total");
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),

                  /// ✅ BAR DATA
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: syncedCount.toDouble(),
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: unsyncedCount.toDouble(),
                          color: Colors.red,
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: totalCount.toDouble(),
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 📌 SUMMARY CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard("Synced", syncedCount, Colors.green),
                _buildCard("Unsynced", unsyncedCount, Colors.red),
                _buildCard("Total", totalCount, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📦 CARD UI
  Widget _buildCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 90,
        child: Column(
          children: [
            Text(
              "$value",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }
}
