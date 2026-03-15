import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/models/mod_bird.dart';

import '../../services/ser_bird.dart';
import '../../widgets/widDialog.dart';
import '../../widgets/widQuizHelper.dart';

class UserGuess {
  String diet = "";
  String family = "";
  String iucnStatus = "";
  String habitat = "";
  String name = "";

  Map<String, Color> colors = {
    'diet': Colors.white,
    'family': Colors.white,
    'iucnStatus': Colors.white,
    'habitat': Colors.white,
    'name': Colors.white,
  };

  bool isComplete() =>
      diet.isNotEmpty && family.isNotEmpty && iucnStatus.isNotEmpty && habitat.isNotEmpty && name.isNotEmpty;

  UserGuess clone() {
    return UserGuess()
      ..diet = diet
      ..family = family
      ..iucnStatus = iucnStatus
      ..habitat = habitat
      ..name = name
      ..colors = Map.from(colors);
  }
}

class QuizBirdleScreen extends StatefulWidget { // TODO remove which are not needed
  final String? quizTitle;
  final int? quizDurationMins;
  final int? quizTotalQuestions;
  final Map<String, dynamic>? quizFilters;
  final Map<String, dynamic>? birdFilters;
  final VoidCallback onQuit;

  const QuizBirdleScreen({super.key,
    this.quizTitle = "Quiz",
    this.quizDurationMins = 2,
    this.quizTotalQuestions = 1,
    this.quizFilters = const {'isStandalone': false},
    this.birdFilters = const {'hasDiet': true, 'hasHabitat': true, 'hasFamily': true, 'hasiucnStatus': true, 'hasImage': true},
    required this.onQuit});
  @override
  State<QuizBirdleScreen> createState() => _QuizBirdleScreenState();
}

class _QuizBirdleScreenState extends State<QuizBirdleScreen> {
  // Timer State
  Timer? _gameTimer;
  late ValueNotifier<Duration> _elapsedNotifier;

  // State variables
  bool _isLoading = true;
  int maxGuesses = 5;
  bool gameEnded = false;
  Set<String> incorrectGuesses = {};
  String imageURL = "";


  //// Game Data
  // Options
  List<ModBird> allBirds = [];
  List<String> allDiets = [];
  List<String> allHabitats = [];
  List<String> allFamilies = [];
  List<String> allStatuses = [];
  List<String> allBirdNames = [];

  // Guesses
  List<UserGuess> guessHistory = [];
  UserGuess currentGuess = UserGuess();
  Map<String, bool> solvedCategories = {'diet': false, 'family': false, 'iucnStatus': false, 'habitat': false, 'name': false};

  // Correct answer
  late UserGuess targetBird = UserGuess();


  @override
  void initState() {
    super.initState();
    _elapsedNotifier = ValueNotifier(Duration.zero);
    _startTimer();
    _syncSolvedValues();
    debugPrint("started timer, syncedSolvedValues");
    _init();
  }

  void _init(){
    //List<String> difficultyList = widget.difficulty.split(',').map((e) => e.trim()).toList();
    allBirds = SerBird.getBirds(limitRows: 5, filters: widget.birdFilters);
    if (!mounted) return;
    setState(() => _isLoading = false);
    debugPrint("allbirds: ${allBirds}");

    if (allBirds.isNotEmpty) {
      final targetModBird = (List.from(allBirds)..shuffle()).first;
      imageURL = targetModBird.featuredImage.imageURL;

      targetBird = UserGuess()
        ..diet = targetModBird.diet
        ..family = targetModBird.family
        ..iucnStatus = targetModBird.iucnStatus
        ..habitat = targetModBird.habitat
        ..name = targetModBird.name;
      debugPrint("targetModBird: ${targetModBird.name}, ${targetModBird.diet}, ${targetModBird.habitat}, ${targetModBird.iucnStatus}");

      setState(() {
        allDiets = allBirds.map((b) => b.diet!).toSet().toList();
        allHabitats = allBirds.map((b) => b.habitat!).toSet().toList();
        allFamilies = allBirds.map((b) => b.family!).toSet().toList();
        allStatuses = allBirds.map((b) => b.iucnStatus!).toSet().toList();
        allBirdNames = allBirds.map((b) => b.name!).toSet().toList();

        // Alphabetical sorting makes selection easier for the user
        allDiets.sort();
        allHabitats.sort();
        allFamilies.sort();
        allBirdNames.sort();
        debugPrint("allDiets: ${allDiets}, ${allHabitats}, ${allFamilies}, ${allBirdNames}");

      });
    }

  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !gameEnded) {
        _elapsedNotifier.value = Duration(seconds: timer.tick);
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
      if (last.colors['diet'] == AppColors.colSecondary) { currentGuess.diet = last.diet; solvedCategories['diet'] = true; }
      if (last.colors['family'] == AppColors.colSecondary) { currentGuess.family = last.family; solvedCategories['family'] = true; }
      if (last.colors['status'] == AppColors.colSecondary) { currentGuess.iucnStatus = last.iucnStatus; solvedCategories['status'] = true; }
      if (last.colors['habitat'] == AppColors.colSecondary) { currentGuess.habitat = last.habitat; solvedCategories['habitat'] = true; }
      if (last.colors['name'] == AppColors.colSecondary) { currentGuess.name = last.name; solvedCategories['name'] = true; }
    }
  }

  void _submitGuess() {
    if (!currentGuess.isComplete()) return;

    bool dCorrect = currentGuess.diet == targetBird.diet;
    bool fCorrect = currentGuess.family == targetBird.family;
    bool sCorrect = currentGuess.iucnStatus == targetBird.iucnStatus;
    bool hCorrect = currentGuess.habitat == targetBird.habitat;
    bool nCorrect = currentGuess.name == targetBird.name;

    setState(() {
      if (!dCorrect) incorrectGuesses.add(currentGuess.diet);
      if (!fCorrect) incorrectGuesses.add(currentGuess.family);
      if (!sCorrect) incorrectGuesses.add(currentGuess.iucnStatus);
      if (!hCorrect) incorrectGuesses.add(currentGuess.habitat);
      if (!nCorrect) incorrectGuesses.add(currentGuess.name);

      currentGuess.colors['diet'] = dCorrect ? AppColors.colSecondary : AppColors.colDisabled;
      currentGuess.colors['family'] = fCorrect ? AppColors.colSecondary : AppColors.colDisabled;
      currentGuess.colors['iucnStatus'] = sCorrect ? AppColors.colSecondary : AppColors.colDisabled;
      currentGuess.colors['habitat'] = hCorrect ? AppColors.colSecondary: AppColors.colDisabled;
      currentGuess.colors['name'] = nCorrect ? AppColors.colSecondary : AppColors.colDisabled;

      guessHistory.add(currentGuess.clone());

      if ((dCorrect && fCorrect && sCorrect && hCorrect && nCorrect) || (guessHistory.length >= maxGuesses)) {
        gameEnded = true;
        _onFinish(guessHistory.length, maxGuesses);
      }
      else {
        currentGuess = UserGuess();
        _syncSolvedValues();
      }
    });
  }
  void _onFinish(int userScore, int maxGuesses) async {
    setState(() {});
    final action = await WidDialog.showResults(
      context,
      title: "Birdle Solved!",
      scoreText: "Solved in ${guessHistory.length} attempt(s)",
      isGuest: false, // Explicitly naming this as well
    );
    action == "restart"
        ? _resetGame()
        : widget.onQuit();
  }
  void _resetGame() {
    setState(() {
      guessHistory.clear();
      currentGuess = UserGuess();
      incorrectGuesses.clear();
      _elapsedNotifier = ValueNotifier(Duration.zero);
      gameEnded = false;
      solvedCategories.updateAll((key, value) => false);
    });
    _gameTimer?.cancel();
    _startTimer();
  }

  void _openSelectionModal(int initialTabIndex) {
    final List<String> tabLabels = ["Diet", "Family", "Status", "Habitat", "Name"];
    AppSheet.show(
      context,
      title: "Guess all attributes correctly!",
      subtitle: "Select for each category:",
      variant: AppSheetVariant.tabbed,
      items: [
        DefaultTabController(
          length: 5,
          initialIndex: 0,
          child: Builder(builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.zero,
                  indicatorColor: AppColors.colTertiary,
                  labelColor: AppColors.colPrimary,
                  unselectedLabelColor: AppColors.colOnDisabled,
                  onTap: (index) {
                    List<String> keys = ['diet', 'family', 'iucnStatus', 'habitat', 'name'];
                    if (solvedCategories[keys[index]]!) {
                      DefaultTabController.of(context).animateTo(initialTabIndex);
                    }
                  },
                  tabs: tabLabels.map((e) => Tab(text: e.toUpperCase())).toList(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildListTab(allDiets, "diet"),
                      _buildListTab(allFamilies, "family"),
                      _buildListTab(allStatuses, "iucnStatus"),
                      _buildListTab(allHabitats, "habitat"),
                      _buildNameSearchTab(),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildListTab(List<String> items, String category) {
    if (solvedCategories[category]!) {
      return Center(child: Text("Solved!", style: AppTypography.subtitle2));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sizeSmall),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isIncorrect = incorrectGuesses.contains(item);

        return AppSheet.buildListItem(
          icon: isIncorrect ? Icons.close : Icons.question_mark,
          text: item,
          onTap: isIncorrect ? () {} : () {
            setState(() {
              if (category == "diet") currentGuess.diet = item;
              if (category == "family") currentGuess.family = item;
              if (category == "iucnStatus") currentGuess.iucnStatus = item;
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
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
        backgroundColor: AppColors.colBackground,

        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/appBg1.webp"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppColors.colBackground.withOpacity(0.65), BlendMode.lighten,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge,),
              child: Column(
                children: [
                  // BIRDLE QUIZ
                  WidQuizHelper.buildTopHeader(context, widget.quizTitle!),

                  // PROGRESS BAR
                  WidQuizHelper.buildProgressBar(guessHistory.length, maxGuesses, _elapsedNotifier),
                  const SizedBox(height: AppSizes.sizeSmall),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.sizeMedium), // Match your image radius
                    child: Stack(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(color: Colors.black.withOpacity(0.2)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded( // Grid
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
                              _buildBox(2, rowData.iucnStatus, isCurrent, Icons.pets, rowData.colors['iucnStatus']!, 'iucnStatus'),
                              _buildBox(3, rowData.habitat, isCurrent, Icons.landscape, rowData.colors['habitat']!, 'habitat'),
                              Expanded(flex: 3, child: _buildBox(4, rowData.name, isCurrent, null, rowData.colors['name']!, 'name', isNameBox: true)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.sizeSmall),

                  AppButton(
                    onPressed: (currentGuess.isComplete() && !gameEnded) ? _submitGuess : null,
                    variant: AppButtonVariant.solid,
                    size: AppButtonSize.large,
                    label: "Submit Guess",
                  ),
                  const SizedBox(height: AppSizes.sizeSmall),


                ],
              ),
            ),
          ),
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
          color: activeRow ? (isLocked ? AppColors.colSecondary : AppColors.colWhite) : (value.isEmpty ? Colors.white : color),
          border: Border.all(color: canTap ? AppColors.colTertiary : Colors.transparent, width: canTap ? 2 : 0.5),
          borderRadius: BorderRadius.circular(AppSizes.sizeSmall),
        ),
        child: Center(
          child: value.isEmpty
              ? (icon != null ? Icon(icon, color: Colors.grey[300]) : const Text("NAME", style: TextStyle(color: Colors.grey, fontSize: 10)))
              : Text(value.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: AppSizes.sizeXSmall, color: (activeRow && !isLocked) ? Colors.black : Colors.white)),
        ),
      ),
    );
  }
}

