import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setDefaultArtwork("assets/cover.png");
    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
        if (kDebugMode) {
          print(metadata);
        }
      });
    });
  }

  void setRadioChannel(String title, String url) {
    _radioPlayer.stop();
    _radioPlayer.setChannel(
      title: title,
      url: url,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      _radioPlayer.play();
    });
  }

  void setIranianRadioChannel() {
    _radioPlayer.stop();
    _radioPlayer.setChannel(
        title: "Iranian Radio", url: "http://37.59.47.192:8200/");
    Future.delayed(const Duration(milliseconds: 500), () {
      _radioPlayer.play();
    });
  }

  String pageTitle = "Pardio";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.yellow,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        )),
        child: Column(
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            Text(
              pageTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: choices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 8.0),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (choices[index].title == "Popcorn") {
                          setRadioChannel("Radio Popcorn",
                              "https://server33930.streamplus.de:43912/stream.mp3");
                        } else if (choices[index].title == "Radio Javan") {
                          setRadioChannel(
                              "Radio Javan", "https://rj1.rjstream.com/");
                        } else if (choices[index].title == "Radio Farda") {
                          setRadioChannel("Radio Farda",
                              "https://n09.radiojar.com/cp13r2cpn3quv");
                        } else if (choices[index].title == "Iranian Radio") {
                          setRadioChannel(
                              "Iranian Radio", "http://37.59.47.192:8200/");
                        }
                        setState(() {
                          pageTitle = choices[index].title;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 235, 59, 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                            choices[index].iconURL,))),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    choices[index].title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                      child: Text(metadata != null
                          ? "${metadata![0]} - ${metadata![1]}"
                          : "",
                      style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.skip_previous,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (metadata == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please choose a Radio")));
                          } else {
                            isPlaying
                                ? _radioPlayer.pause()
                                : _radioPlayer.play();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 27,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.skip_next,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

const List<Choice> choices = <Choice>[
  Choice(
      title: 'Radio Javan',
      iconURL: "https://www.radiojavan.com/images/default_fb.png"),
  Choice(
      title: 'Popcorn',
      iconURL:
          "https://news.radiopopcorn.de/wp-content/uploads/2020/07/LOGO-S-1.png"),
  Choice(
      title: 'Radio Farda',
      iconURL:
          "https://www.phonostar.de/images/auto_created/Radio_Farda184x184.png"),
  Choice(
      title: 'Iranian Radio',
      iconURL:
          "https://liveonlineradio.net/wp-content/uploads/2011/12/iranian-radio.jpeg"),
];

class Choice {
  const Choice({required this.title, required this.iconURL});

  final String title;
  final String iconURL;
}
