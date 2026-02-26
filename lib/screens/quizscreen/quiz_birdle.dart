import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/widgets/widQuizHelper.dart';

class UserGuess {
  String diet = "";
  String family = "";
  String status = "";
  String habitat = "";
  String name = "";

  Map<String, Color> colors = {
    'diet': Colors.white,
    'family': Colors.white,
    'status': Colors.white,
    'habitat': Colors.white,
    'name': Colors.white,
  };

  bool isComplete() =>
      diet.isNotEmpty && family.isNotEmpty && status.isNotEmpty && habitat.isNotEmpty && name.isNotEmpty;

  UserGuess clone() {
    return UserGuess()
      ..diet = diet
      ..family = family
      ..status = status
      ..habitat = habitat
      ..name = name
      ..colors = Map.from(colors);
  }
}

class QuizBirdleScreen extends StatefulWidget {
  const QuizBirdleScreen({super.key});

  @override
  State<QuizBirdleScreen> createState() => _QuizBirdleScreenState();
}

class _QuizBirdleScreenState extends State<QuizBirdleScreen> {
  // Timer State
  Timer? _gameTimer;
  int _secondsElapsed = 0;

  // Mock Database
  final List<String> allDiets = ["Insects", "Fish", "Seeds", "Berries", "Crustaceans"];
  final List<String> allHabitats = ["Wetlands", "Forest", "Grassland", "Coastal", "Urban"];
  final List<String> allFamilies = ["Ardeidae", "Accipitridae", "Columbidae", "Gruidae"];
  final List<String> allStatuses = ["LC", "NT", "VU", "EN", "CR"];
  final List<String> allBirdNames = ["ASIAN OPENBILL", "BLUE CRANE", "KINGFISHER", "SNOWY EGRET", "GREAT HORNBILL", "INDIAN PEAFOWL"];

  final UserGuess targetBird = UserGuess()
    ..diet = "Seeds"
    ..family = "Gruidae"
    ..status = "VU"
    ..habitat = "Grassland"
    ..name = "BLUE CRANE";

  List<UserGuess> guessHistory = [];
  UserGuess currentGuess = UserGuess();
  final int maxGuesses = 5;
  bool gameEnded = false;
  Set<String> incorrectGuesses = {};
  Map<String, bool> solvedCategories = {'diet': false, 'family': false, 'status': false, 'habitat': false, 'name': false};

  @override
  void initState() {
    super.initState();
    _startTimer();
    _syncSolvedValues();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !gameEnded) {
        setState(() => _secondsElapsed++);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _syncSolvedValues() {
    if (guessHistory.isNotEmpty) {
      UserGuess last = guessHistory.last;
      if (last.colors['diet'] == Colors.green) { currentGuess.diet = last.diet; solvedCategories['diet'] = true; }
      if (last.colors['family'] == Colors.green) { currentGuess.family = last.family; solvedCategories['family'] = true; }
      if (last.colors['status'] == Colors.green) { currentGuess.status = last.status; solvedCategories['status'] = true; }
      if (last.colors['habitat'] == Colors.green) { currentGuess.habitat = last.habitat; solvedCategories['habitat'] = true; }
      if (last.colors['name'] == Colors.green) { currentGuess.name = last.name; solvedCategories['name'] = true; }
    }
  }

  void _submitGuess() {
    if (!currentGuess.isComplete()) return;

    bool dCorrect = currentGuess.diet == targetBird.diet;
    bool fCorrect = currentGuess.family == targetBird.family;
    bool sCorrect = currentGuess.status == targetBird.status;
    bool hCorrect = currentGuess.habitat == targetBird.habitat;
    bool nCorrect = currentGuess.name == targetBird.name;

    setState(() {
      if (!dCorrect) incorrectGuesses.add(currentGuess.diet);
      if (!fCorrect) incorrectGuesses.add(currentGuess.family);
      if (!sCorrect) incorrectGuesses.add(currentGuess.status);
      if (!hCorrect) incorrectGuesses.add(currentGuess.habitat);
      if (!nCorrect) incorrectGuesses.add(currentGuess.name);

      currentGuess.colors['diet'] = dCorrect ? Colors.green : Colors.grey;
      currentGuess.colors['family'] = fCorrect ? Colors.green : Colors.grey;
      currentGuess.colors['status'] = sCorrect ? Colors.green : Colors.grey;
      currentGuess.colors['habitat'] = hCorrect ? Colors.green : Colors.grey;
      currentGuess.colors['name'] = nCorrect ? Colors.green : Colors.grey;

      guessHistory.add(currentGuess.clone());

      if (dCorrect && fCorrect && sCorrect && hCorrect && nCorrect) {
        gameEnded = true;
      } else if (guessHistory.length >= maxGuesses) {
        gameEnded = true;
      } else {
        currentGuess = UserGuess();
        _syncSolvedValues();
      }
    });
  }

  void _resetGame() {
    setState(() {
      guessHistory.clear();
      currentGuess = UserGuess();
      incorrectGuesses.clear();
      _secondsElapsed = 0;
      gameEnded = false;
      solvedCategories.updateAll((key, value) => false);
    });
    _gameTimer?.cancel();
    _startTimer();
  }

  void _openSelectionModal(int initialTabIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DefaultTabController(
          length: 5,
          initialIndex: initialTabIndex,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                TabBar(
                  labelColor: AppColors.colPrimary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.colOnTertiary,
                  indicatorWeight: 3,
                  isScrollable: true,
                  onTap: (index) {
                    List<String> keys = ['diet', 'family', 'status', 'habitat', 'name'];
                    if (solvedCategories[keys[index]]!) {
                      DefaultTabController.of(context).animateTo(initialTabIndex);
                    }
                  },
                  tabs: [
                    Tab(text: "Diet"), Tab(text: "Family"), Tab(text: "Status"), Tab(text: "Habitat"), Tab(text: "Name"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildListTab(allDiets, "diet"),
                      _buildListTab(allFamilies, "family"),
                      _buildListTab(allStatuses, "status"),
                      _buildListTab(allHabitats, "habitat"),
                      _buildNameSearchTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTab(List<String> items, String category) {
    if (solvedCategories[category]!) return const Center(child: Text("Already Solved!"));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isIncorrect = incorrectGuesses.contains(item);
        return ListTile(
          enabled: !isIncorrect,
          title: Text(item, style: TextStyle(color: isIncorrect ? Colors.grey[300] : Colors.black, decoration: isIncorrect ? TextDecoration.lineThrough : null)),
          onTap: () {
            setState(() {
              if (category == "diet") currentGuess.diet = item;
              if (category == "family") currentGuess.family = item;
              if (category == "status") currentGuess.status = item;
              if (category == "habitat") currentGuess.habitat = item;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildNameSearchTab() {
    if (solvedCategories['name']!) return const Center(child: Text("Already Solved!"));
    String query = "";
    return StatefulBuilder(builder: (context, setModalState) {
      final filteredList = allBirdNames.where((name) => name.contains(query.toUpperCase())).toList();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search bird name...",
                prefixIcon: const Icon(Icons.search, color: AppColors.colPrimary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setModalState(() => query = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final name = filteredList[index];
                final bool isIncorrect = incorrectGuesses.contains(name);
                return ListTile(
                  enabled: !isIncorrect,
                  title: Text(name, style: TextStyle(color: isIncorrect ? Colors.grey[300] : Colors.black, decoration: isIncorrect ? TextDecoration.lineThrough : null)),
                  onTap: () {
                    setState(() => currentGuess.name = name);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BIRDLE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _resetGame)],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/Asian Openbill_wiki_9.png"), fit: BoxFit.cover),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
              ),
              // Positioned(
              //   top: 15, right: 15,
              //   // child: WidQuizHelper.infoChip(
              //   //   WidQuizHelper.formatTime(Duration(seconds: _secondsElapsed)),
              //   //   color: Colors.black.withOpacity(0.6),
              //   // ),
              // ),
              const Positioned(bottom: 15, left: 15, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.volume_up, color: AppColors.colPrimary))),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: maxGuesses,
              itemBuilder: (context, index) {
                bool isPast = index < guessHistory.length;
                bool isCurrent = index == guessHistory.length;
                UserGuess rowData = isPast ? guessHistory[index] : (isCurrent ? currentGuess : UserGuess());
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      _buildBox(0, rowData.diet, isCurrent, Icons.bug_report, rowData.colors['diet']!, 'diet'),
                      _buildBox(1, rowData.family, isCurrent, Icons.flutter_dash, rowData.colors['family']!, 'family'),
                      _buildBox(2, rowData.status, isCurrent, Icons.pets, rowData.colors['status']!, 'status'),
                      _buildBox(3, rowData.habitat, isCurrent, Icons.landscape, rowData.colors['habitat']!, 'habitat'),
                      Expanded(flex: 3, child: _buildBox(4, rowData.name, isCurrent, null, rowData.colors['name']!, 'name', isNameBox: true)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: (currentGuess.isComplete() && !gameEnded) ? _submitGuess : null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.colPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("GUESS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBox(int tabIdx, String value, bool activeRow, IconData? icon, Color color, String key, {bool isNameBox = false}) {
    bool isLocked = solvedCategories[key]!;
    bool canTap = activeRow && !isLocked;
    return GestureDetector(
      onTap: canTap ? () => _openSelectionModal(tabIdx) : null,
      child: Container(
        height: 60, width: isNameBox ? null : 65, margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: activeRow ? (isLocked ? Colors.green : Colors.white) : (value.isEmpty ? Colors.white : color),
          border: Border.all(color: canTap ? AppColors.colPrimary : Colors.grey[300]!, width: canTap ? 2 : 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: value.isEmpty
              ? (icon != null ? Icon(icon, color: Colors.grey[300]) : const Text("NAME", style: TextStyle(color: Colors.grey, fontSize: 10)))
              : Text(value.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: (activeRow && !isLocked) ? Colors.black : Colors.white)),
        ),
      ),
    );
  }
}