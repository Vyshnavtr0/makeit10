import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:confetti/confetti.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sortable_wrap/sortable_wrap.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:math_game/device.dart';
import 'package:math_game/level.dart';
import 'package:math_game/tutorial.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Random _random = Random();
  ConfettiController _controllerwin = ConfettiController();
  List<int> numbers = [0, 0, 0, 0];
  bool check_win = false;
  List<int> droppedNumber = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  Widget drop({
    required int i,
    required List<int> tar,
    required int dra,
    required BuildContext context,
  }) {
    String t = '';
    if (droppedNumber[i] == 11) {
      t = '(';
    } else if (droppedNumber[i] == 22) {
      t = '+';
    } else if (droppedNumber[i] == 33) {
      t = '-';
    } else if (droppedNumber[i] == 44) {
      t = '×';
    } else if (droppedNumber[i] == 55) {
      t = '÷';
    } else if (droppedNumber[i] == 66) {
      t = ')';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: droppedNumber[i] == 0 || tar.contains(dra)
          ? AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              height: DeviceUtils.isPhone(context) ? 50 : 100,
              width: DeviceUtils.isPhone(context) ? 30 : 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white30),
              child: Center(
                child: Draggable<int>(
                  data: droppedNumber[i],
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      drag_num = 0;
                      droppedNumber[i] = 0;
                    });
                  },
                  onDragUpdate: (details) {
                    setState(() {
                      drag_num = droppedNumber[i];
                      drag = true;
                    });
                    print(drag);
                  },
                  onDragCompleted: () {
                    setState(() {
                      drag_num = 0;
                      drag = false;
                      droppedNumber[i] = 0;
                    });
                    if (check_win == false) express();
                    print(drag);
                  },
                  onDragStarted: () {
                    setState(() {
                      drag_num = droppedNumber[i];
                      drag = true;
                    });
                    print(drag);
                  },
                  onDragEnd: (details) {
                    setState(() {
                      drag_num = 0;
                      drag = false;
                      droppedNumber[i] = 0;
                    });
                    if (check_win == false) express();
                    print(drag);
                  },
                  feedback: Text(
                    i != 0 ? '$t' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white30,
                        fontSize: DeviceUtils.isPhone(context) ? 30 : 55,
                        fontWeight: FontWeight.bold),
                  ),
                  child: Text(
                    droppedNumber[i] != 0 ? '$t' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            )
          : AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: DeviceUtils.isPhone(context) ? 50 : 100,
              width: DeviceUtils.isPhone(context) ? 10 : 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent),
              child: Center(
                child: Draggable<int>(
                  data: droppedNumber[i],
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      drag_num = 0;
                      droppedNumber[i] = 0;
                    });
                  },
                  onDragUpdate: (details) {
                    setState(() {
                      drag_num = droppedNumber[i];
                      drag = true;
                    });
                    print(drag);
                  },
                  onDragCompleted: () {
                    setState(() {
                      drag_num = 0;
                      drag = false;
                    });
                    if (check_win == false) express();
                    print(drag);
                  },
                  onDragStarted: () {
                    setState(() {
                      drag_num = droppedNumber[i];
                      drag = true;
                    });
                    print(drag);
                  },
                  onDragEnd: (details) {
                    setState(() {
                      drag_num = 0;
                      drag = false;
                    });
                    if (check_win == false) express();
                    print(drag);
                  },
                  childWhenDragging: Text(
                    droppedNumber[i] != 0 ? '$t' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white10,
                        fontSize: DeviceUtils.isPhone(context) ? 30 : 55,
                        fontWeight: FontWeight.bold),
                  ),
                  feedback: Text(
                    droppedNumber[i] != 0 ? '$t' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: DeviceUtils.isPhone(context) ? 30 : 55,
                        fontWeight: FontWeight.bold),
                  ),
                  child: Text(
                    droppedNumber[i] != 0 ? '$t' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: DeviceUtils.isPhone(context) ? 30 : 55,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
    );
  }

  void _resetGame() {
    if (currentLevel < levels.length) {
      setState(() {
        numbers = levels[currentLevel].numbers;
        droppedNumber = List<int>.filled(13, 0);
        ans = -1;
        text = '';
      });
      _playrest();
    }
  }

  final _solutioncontroller = PageController();
  List<String> solutions = [];
  Map<int, DateTime?> levelLastViewedTime = {};
  Set<int> levelsViewedToday = {};
  int currentLevel = 0; // Replace with actual current level
  int dailyLimit = 3;
  DateTime lastResetTime = DateTime.now();
  Timer? resetTimer;
  @override
  void initState() {
    super.initState();
    _loadState();
    loadCurLev();
    _resetDailyCounter();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      lastResetTime = DateTime.parse(
          prefs.getString('lastResetTime') ?? DateTime.now().toIso8601String());

      // Load levelsViewedToday
      levelsViewedToday = (prefs.getStringList('levelsViewedToday') ?? [])
          .map((s) => int.parse(s))
          .toSet();

      // Load levelLastViewedTime
      Map<String, String> tempMap =
          (prefs.getString('levelLastViewedTime') ?? '{}')
              .replaceAll(RegExp(r'[{}]'), '')
              .split(',')
              .map((s) => s.split(':'))
              .where((pair) => pair.length == 2)
              .fold<Map<String, String>>({}, (map, pair) {
        map[pair[0]] = pair[1];
        return map;
      });

      levelLastViewedTime = tempMap.map(
          (key, value) => MapEntry(int.parse(key), DateTime.tryParse(value)));
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('lastResetTime', lastResetTime.toIso8601String());
    await prefs.setStringList('levelsViewedToday',
        levelsViewedToday.map((e) => e.toString()).toList());
    await prefs.setString(
        'levelLastViewedTime',
        levelLastViewedTime
            .map((k, v) => MapEntry(k.toString(), v?.toIso8601String() ?? ''))
            .toString());
  }

  void _resetDailyCounter() {
    resetTimer = Timer.periodic(Duration(hours: 24), (timer) {
      setState(() {
        levelsViewedToday.clear();
        lastResetTime = DateTime.now();
        _saveState();
      });
    });
  }

  @override
  void dispose() {
    resetTimer?.cancel();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    DateTime now = DateTime.now();

    // Reset daily counter if it's a new day
    if (now.difference(lastResetTime).inDays >= 1) {
      setState(() {
        levelsViewedToday.clear();
        lastResetTime = now;
        _saveState();
      });
    }

    // Check if daily limit reached
    if (levelsViewedToday.length >= dailyLimit &&
        !levelsViewedToday.contains(currentLevel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Daily limit of viewing solutions reached. Please try again tomorrow.')),
      );
      return;
    }

    DateTime? lastViewedTime = levelLastViewedTime[currentLevel];

    // If the solution for the current level has been viewed within the last 5 minutes, show a warning
    if (lastViewedTime != null &&
        now.difference(lastViewedTime).inMinutes < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please wait for 5 minutes before viewing the solutions again.')),
      );
      return;
    }

    // Show the solution and update the view count and last viewed time
    _showSolutionBottomSheet(context);

    setState(() {
      levelLastViewedTime[currentLevel] = now;
      levelsViewedToday.add(currentLevel);
      _saveState();
    });
  }

  void _showSolutionBottomSheet(BuildContext context) {
    solutions.clear();

    bool result = findSolution(
      levels[currentLevel].numbers,
      10,
      solutions: solutions,
      allowAddition: levels[currentLevel].remove.contains(22) ? false : true,
      allowSubtraction: levels[currentLevel].remove.contains(33) ? false : true,
      allowMultiplication:
          levels[currentLevel].remove.contains(44) ? false : true,
      allowDivision: levels[currentLevel].remove.contains(55) ? false : true,
      allowParentheses: levels[currentLevel].remove.contains(66) ? false : true,
    );

    if (result) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Solutions (${solutions.length})',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Remaining views today: ${dailyLimit - levelsViewedToday.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          _solutioncontroller.previousPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    BannerCarousel(
                      animation: false,
                      pageController: _solutioncontroller,
                      viewportFraction: 5,
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      showIndicator: false,
                      customizedBanners: buildSolutionsListWidgets(
                        solutions,
                        context,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _solutioncontroller.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_forward_ios)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No solutions found.')),
      );
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playrest() async {
    await _audioPlayer.play('assets/sounds/reset.mp3');
    _audioPlayer.resume();
  }

  void _playwin() async {
    await _audioPlayer.play('assets/sounds/win.mp3');
    _audioPlayer.resume();
  }

  bool sort = false;
  bool drag = false;
  int drag_num = 0;
  int num_drag = -1;
  List<int> sym = [11, 22, 33, 44, 55, 66];
  double ans = -1;
  String text = '';
  Future<void> express() async {
    setState(() {
      check_win = true;
    });
    text = '';
    for (int i = 0; i < 13; i++) {
      if (i == 1) {
        text += numbers[0].toString();
      } else if (i == 4) {
        text += numbers[1].toString();
      } else if (i == 8) {
        text += numbers[2].toString();
      } else if (i == 11) {
        text += numbers[3].toString();
      } else {
        if (droppedNumber[i] == 11) {
          text += '(';
        } else if (droppedNumber[i] == 22) {
          text += '+';
        } else if (droppedNumber[i] == 33) {
          text += '-';
        } else if (droppedNumber[i] == 44) {
          text += '*';
        } else if (droppedNumber[i] == 55) {
          text += '/';
        } else if (droppedNumber[i] == 66) {
          text += ')';
        }
      }
    }
    try {
      final expression = Expression.parse(text);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      if (result is num) {
        if (droppedNumber[2] != 0 &&
            droppedNumber[6] != 0 &&
            droppedNumber[10] != 0) {
          setState(() {
            ans = result.toDouble();
          });
          if (ans == levels[currentLevel].goal) {
            OverlayLoadingProgress.start(context, barrierDismissible: false);
            _controllerwin.play();
            await Future.delayed(const Duration(milliseconds: 1000));
            _controllerwin.stop();
            if (currentLevel < 100) {
              setState(() {
                // Obtain shared preferences.
                currentLevel++;
                loadLevel(currentLevel);
                _playwin();
                prefs.setInt('level', currentLevel);
              });
              if (currentLevel == 7) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => LevelWarningBottomSheet(),
                );
              }
            } else {
              setState(() {
                // Obtain shared preferences.
                currentLevel = 0;
                loadLevel(currentLevel);
                _playwin();
                prefs.setInt('level', currentLevel);
              });
            }

            OverlayLoadingProgress.stop();
            setState(() {
              check_win = false;
            });
          }
        } else {
          setState(() {
            ans = -1;
          });
        }
      } else {
        setState(() {
          ans = -1;
        });
      }
    } catch (e) {
      setState(() {
        ans = -1;
      });
      print(e);
      print(text);
    }
    setState(() {
      check_win = false;
    });
  }

  final List<String> bgImages = [
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327522/Under_The_Blazing_Moon27638_rectangle_20240624_144804_772_77_thblzs.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327510/The_Red_Planet16087_rectangle_20240624_144630_112_49_mhb4rg.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327498/Racing_Home12147_rectangle_20240624_144829_498_75_lnykof.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327487/Purple_Night17946_rectangle_20240624_144705_673_15_oklk92.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327475/Evening_Breeze25415_rectangle_20240624_144907_067_35_fc3etv.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327474/Pulp_Vision27402_rectangle_20240624_144543_857_49_nkt7ji.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327472/A_Galaxy_Away22311_rectangle_20240624_144613_018_68_vrk7ko.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379582/Lunar_lullaby33855_rectangle_20240626_104804_433_24_gdhdrv.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379580/Mama_Kitty28565_rectangle_20240626_104304_451_64_h5t5wy.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379581/Enigmatic_evening33853_rectangle_20240626_104820_525_51_abtp6p.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379581/Kids_in_Halloween32210_rectangle_20240626_105043_350_51_to0noy.png',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379574/The_monster3382_rectangle_20240626_103751_598_77_t1sdsl.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379571/Witches_House31772_rectangle_20240626_105105_402_20_br2ats.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379571/Llover13527_rectangle_20240626_103729_599_59_blqkxy.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379567/RADIANCE23252_rectangle_20240626_104457_784_17_f5lmsw.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379565/DYSTOPIA23389_rectangle_20240626_104148_387_18_mvk5ys.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379561/Stairway_To_The_Moon27201_rectangle_20240626_104031_884_17_ureesu.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379561/Stairway_To_The_Moon27201_rectangle_20240626_104031_884_17_ureesu.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379553/First_light2864_rectangle_20240626_104042_682_37_nsslpw.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379549/Into_the_lightning9566_rectangle_20240626_104049_686_38_zlhem2.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379546/Solitary_Full_Moon27640_rectangle_20240626_104540_439_43_eobzu9.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379543/Dark_allure33658_rectangle_20240626_104845_608_5_xtojgq.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379537/Peaceful_Night_v429719_rectangle_20240626_104638_261_70_wimcby.jpg',
    'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379534/Dark_Red_Nature31604_rectangle_20240626_103825_769_54_ozi1ex.jpg'
  ];

  // Variable to hold the selected background image
  String selectedBgImage =
      "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719327472/A_Galaxy_Away22311_rectangle_20240624_144613_018_68_vrk7ko.jpg";

  late final SharedPreferences prefs;
  Future<void> loadCurLev() async {
    prefs = await SharedPreferences.getInstance();
    currentLevel = prefs.getInt('level') ?? 0; // Use default value 0 if null
    loadLevel(currentLevel);
  }

  void loadLevel(int level) {
    if (level < levels.length) {
      setState(() {
        numbers = levels[level].numbers;
        droppedNumber = List<int>.filled(13, 0);
        ans = -1;
        text = '';
      });
    }
    selectedBgImage = bgImages[_random.nextInt(bgImages.length)];
    if (level == 99) {
      selectedBgImage =
          'https://res.cloudinary.com/dvhlfyvrr/image/upload/v1719379561/digital_art_of_Batman_captured_in_a_fierce_mood_set_i31224_rectangle_20240626_105138_614_9_ehgtqm.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              _resetGame();
            },
            icon: Icon(
              Icons.repeat,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              //print(findSolution(numbers, 10));
              //print(generateLevels());
              _showBottomSheet(context);
            },
            icon: Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'Make it 10',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),
      body: Stack(
        children: [
          Image.network(
            selectedBgImage,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Visibility(
            visible: currentLevel == 99 ? true : false,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ParallaxRain(
                dropFallSpeed: 5,
                dropHeight: 5,
                numberOfDrops: 500,
                trail: true,
                dropWidth: 0.2,
                dropColors: [Colors.white10.withOpacity(0.5)],
                child: Text(
                  "",
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 14,
                  ),
                  Text(
                    '${currentLevel + 1} / ${levels.length}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 9,
                  ),
                  Text(
                    ans == -1
                        ? "?"
                        : (ans.toString().length > 6
                            ? ans.toString().substring(0, 6)
                            : ans.toString()),
                    style: TextStyle(fontSize: 100, color: Colors.white),
                  ),
                  Spacer()
                ],
              ),
            ),
          ),
          Center(
              child: droppedNumber[0] == 0 &&
                      droppedNumber[1] == 0 &&
                      droppedNumber[2] == 0 &&
                      droppedNumber[3] == 0 &&
                      droppedNumber[4] == 0 &&
                      droppedNumber[5] == 0 &&
                      droppedNumber[6] == 0 &&
                      droppedNumber[7] == 0 &&
                      droppedNumber[8] == 0 &&
                      droppedNumber[9] == 0 &&
                      droppedNumber[10] == 0 &&
                      droppedNumber[11] == 0 &&
                      droppedNumber[12] == 0 &&
                      drag == false
                  ? SortableWrap(
                      onSortStart: (index) {
                        setState(() {
                          sort = true;
                        });
                        print(numbers);
                      },
                      children: [
                        Container(
                          height: DeviceUtils.isPhone(context) ? 50 : 100,
                          width: DeviceUtils.isPhone(context) ? 30 : 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent),
                          child: Center(
                            child: Text(
                              '${numbers[0]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      DeviceUtils.isPhone(context) ? 30 : 70,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Container(
                          height: DeviceUtils.isPhone(context) ? 50 : 100,
                          width: DeviceUtils.isPhone(context) ? 50 : 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent),
                          child: Center(
                            child: Text(
                              '${numbers[1]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      DeviceUtils.isPhone(context) ? 30 : 70,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Container(
                          height: DeviceUtils.isPhone(context) ? 50 : 100,
                          width: DeviceUtils.isPhone(context) ? 50 : 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent),
                          child: Center(
                            child: Text(
                              '${numbers[2]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      DeviceUtils.isPhone(context) ? 30 : 70,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Container(
                          height: DeviceUtils.isPhone(context) ? 50 : 100,
                          width: DeviceUtils.isPhone(context) ? 50 : 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent),
                          child: Center(
                            child: Text(
                              '${numbers[3]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      DeviceUtils.isPhone(context) ? 30 : 70,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                      onSorted: (int oldIndex, int newIndex) {
                        setState(() {
                          numbers.insert(newIndex, numbers.removeAt(oldIndex));
                          print('----->>>>> your_data_array: $numbers');
                        });
                        setState(() {
                          sort = false;
                        });
                      },
                      spacing: 10,
                      runSpacing: 15,
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: drag_num == 11 || droppedNumber[0] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 11) {
                                        setState(() {
                                          droppedNumber[0] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [11],
                                          i: 0);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Draggable<int>(
                            data: 0,
                            feedback: NumWid(0, true),
                            child: NumWid(0, true),
                            childWhenDragging: NumWid(0, false),
                            onDragUpdate: (details) {
                              setState(() {
                                num_drag = 0;
                              });
                              print(drag);
                            },
                            onDragCompleted: () {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                            onDragStarted: () {
                              setState(() {
                                num_drag = 0;
                              });
                              print(drag);
                            },
                            onDragEnd: (details) {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                          ),
                          Container(
                            child: drag_num == 22 ||
                                    drag_num == 33 ||
                                    drag_num == 44 ||
                                    drag_num == 55 ||
                                    droppedNumber[2] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (drag_num == 22 ||
                                          drag_num == 33 ||
                                          drag_num == 44 ||
                                          drag_num == 55) {
                                        setState(() {
                                          droppedNumber[2] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [22, 33, 44, 55],
                                          i: 2);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Container(
                            child: drag_num == 11 || droppedNumber[3] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 11) {
                                        setState(() {
                                          droppedNumber[3] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [11],
                                          i: 3);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Draggable<int>(
                            data: 1,
                            feedback: NumWid(1, true),
                            child: NumWid(1, true),
                            childWhenDragging: NumWid(1, false),
                            onDragUpdate: (details) {
                              setState(() {
                                num_drag = 1;
                              });
                              print(drag);
                            },
                            onDragCompleted: () {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                            onDragStarted: () {
                              setState(() {
                                num_drag = 1;
                              });
                              print(drag);
                            },
                            onDragEnd: (details) {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                          ),
                          Container(
                            child: drag_num == 66 || droppedNumber[5] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 66) {
                                        setState(() {
                                          droppedNumber[5] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [66],
                                          i: 5);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Container(
                            child: drag_num == 22 ||
                                    drag_num == 33 ||
                                    drag_num == 44 ||
                                    drag_num == 55 ||
                                    droppedNumber[6] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (drag_num == 22 ||
                                          drag_num == 33 ||
                                          drag_num == 44 ||
                                          drag_num == 55) {
                                        setState(() {
                                          droppedNumber[6] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [22, 33, 44, 55],
                                          i: 6);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Container(
                            child: drag_num == 11 || droppedNumber[7] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 11) {
                                        setState(() {
                                          droppedNumber[7] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [11],
                                          i: 7);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Draggable<int>(
                            data: 2,
                            feedback: NumWid(2, true),
                            child: NumWid(2, true),
                            childWhenDragging: NumWid(2, false),
                            onDragUpdate: (details) {
                              setState(() {
                                num_drag = 2;
                              });
                              print(drag);
                            },
                            onDragCompleted: () {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                            onDragStarted: () {
                              setState(() {
                                num_drag = 2;
                              });
                              print(drag);
                            },
                            onDragEnd: (details) {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                          ),
                          Container(
                            child: drag_num == 66 || droppedNumber[9] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 66) {
                                        setState(() {
                                          droppedNumber[9] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [66],
                                          i: 9);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Container(
                            child: drag_num == 22 ||
                                    drag_num == 33 ||
                                    drag_num == 44 ||
                                    drag_num == 55 ||
                                    droppedNumber[10] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (drag_num == 22 ||
                                          drag_num == 33 ||
                                          drag_num == 44 ||
                                          drag_num == 55) {
                                        setState(() {
                                          droppedNumber[10] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [22, 33, 44, 55],
                                          i: 10);
                                    },
                                  )
                                : SizedBox(),
                          ),
                          Draggable<int>(
                            data: 3,
                            feedback: NumWid(3, true),
                            child: NumWid(3, true),
                            childWhenDragging: NumWid(3, false),
                            onDragUpdate: (details) {
                              setState(() {
                                num_drag = 3;
                              });
                              print(drag);
                            },
                            onDragCompleted: () {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                            onDragStarted: () {
                              setState(() {
                                num_drag = 3;
                              });
                              print(drag);
                            },
                            onDragEnd: (details) {
                              setState(() {
                                num_drag = -1;
                              });
                              if (check_win == false) express();
                              print(drag);
                            },
                          ),
                          Container(
                            child: drag_num == 66 || droppedNumber[12] != 0
                                ? DragTarget<int>(
                                    onAccept: (data) {
                                      if (data == 66) {
                                        setState(() {
                                          droppedNumber[12] = data;
                                        });
                                      }
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return drop(
                                          context: context,
                                          dra: drag_num,
                                          tar: [66],
                                          i: 12);
                                    },
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    )),
          SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: sym.map((number) {
                      String t = '';
                      if (number == 11) {
                        t = '(';
                      } else if (number == 22) {
                        t = '+';
                      } else if (number == 33) {
                        t = '-';
                      } else if (number == 44) {
                        t = '×';
                      } else if (number == 55) {
                        t = '÷';
                      } else if (number == 66) {
                        t = ')';
                      }
                      return levels[currentLevel].remove.contains(number)
                          ? Container(
                              height: DeviceUtils.isPhone(context) ? 60 : 100,
                              width: DeviceUtils.isPhone(context) ? 40 : 100,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  '$t',
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: t == ')' || t == '('
                                          ? DeviceUtils.isPhone(context)
                                              ? 40
                                              : 60
                                          : DeviceUtils.isPhone(context)
                                              ? 30
                                              : 50,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            )
                          : Draggable<int>(
                              data: number,
                              child:
                                  DraggableCard(context, number, false, true),
                              feedback:
                                  DraggableCard(context, number, false, true),
                              onDragUpdate: (details) {
                                setState(() {
                                  drag = true;
                                  drag_num = number;
                                });
                                print(drag);
                              },
                              onDragCompleted: () {
                                setState(() {
                                  drag = false;
                                  drag_num = 0;
                                });
                                if (check_win == false) express();
                                print(drag);
                              },
                              onDragStarted: () {
                                setState(() {
                                  drag = true;
                                  drag_num = number;
                                });
                                print(drag);
                              },
                              onDragEnd: (details) {
                                setState(() {
                                  drag = false;
                                  drag_num = 0;
                                });
                                if (check_win == false) express();
                                print(drag);
                              },
                              childWhenDragging:
                                  DraggableCard(context, number, true, false),
                            );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => HowToPlayBottomSheet(),
                    );
                  },
                  child: Text(
                    'How to Play ?',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: DeviceUtils.isPhone(context) ? 10 : 12,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerwin,
              shouldLoop: true,
              blastDirection: 3.14 / 2,
              minimumSize: Size(1, 10),
              maximumSize: Size(10, 20),
              colors: [
                Colors.green,
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.purple,
                Colors.white,
                Colors.orange,
                Colors.indigo,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  DragTarget NumWid(int num, bool f) {
    return DragTarget<int>(
      onAccept: (data) {
        if (data > -1 && data < 10)
          setState(() {
            int t = numbers[num];
            numbers[num] = numbers[data];
            numbers[data] = t;
          });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: DeviceUtils.isPhone(context) ? 50 : 100,
          width: DeviceUtils.isPhone(context) ? 30 : 100,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: num_drag != num && num_drag != -1
                  ? Colors.white38
                  : Colors.transparent),
          child: Center(
            child: Text(
              '${numbers[num]}',
              style: TextStyle(
                  color: f ? Colors.white : Colors.white30,
                  fontSize: DeviceUtils.isPhone(context) ? 30 : 70,
                  fontWeight: FontWeight.w900),
            ),
          ),
        );
      },
    );
  }
}

Padding DraggableCard(BuildContext context, int number, bool dragging, bool f) {
  String t = '';
  if (number == 11) {
    t = '(';
  } else if (number == 22) {
    t = '+';
  } else if (number == 33) {
    t = '-';
  } else if (number == 44) {
    t = '×';
  } else if (number == 55) {
    t = '÷';
  } else if (number == 66) {
    t = ')';
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: DeviceUtils.isPhone(context) ? 60 : 100,
      width: DeviceUtils.isPhone(context) ? 40 : 100,
      decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          '$t',
          style: TextStyle(
              color: f ? Colors.white : Colors.white30,
              fontSize: t == ')' || t == '('
                  ? DeviceUtils.isPhone(context)
                      ? 40
                      : 60
                  : DeviceUtils.isPhone(context)
                      ? 30
                      : 50,
              fontWeight: FontWeight.w900),
        ),
      ),
    ),
  );
}

int countOpeningParentheses(String solution) {
  int count = 0;
  for (int i = 0; i < solution.length; i++) {
    if (solution[i] == '(') {
      count++;
    }
  }
  return count;
}

List<Widget> buildSolutionsListWidgets(
    List<String> solutions, BuildContext context) {
  List<Widget> widgets = [];
  solutions.sort((a, b) =>
      countOpeningParentheses(a).compareTo(countOpeningParentheses(b)));
  for (String solution in solutions) {
    widgets.add(
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Text(
            solution.replaceAll('10.00', '10'), // Replace specific format
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
    // Add spacing between items
  }

  return widgets;
}
