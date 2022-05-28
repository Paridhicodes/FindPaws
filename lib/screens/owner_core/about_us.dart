import 'package:find_paws_engage/components/AppBarInit.dart';
import 'package:find_paws_engage/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  static const String id = "about_us";
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBarInit(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Our Mission',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'We at findPAWS understand that pets are no less than a family to '
                        'the pet parents. We realize that how fearful it is for a family when their pets go missing.'
                        ' findPaws is made with the spirit and benevolance to help the worried pet parents reach their dogs at the earliest, if they ever go missing. '
                        '\n\n "Let\'s make this world a better place for pets."',
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'How do we do this?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'findPAWS, uses face recognition technology to identify the breeds of the dogs. All the dogs have a unique ID and their breed (which is determined by our specially trained models and face-recognition technology) and other information is recorded with us.'
                        ' Whenever, the pet owners mark their dog as lost, the current location of the owner is recorded. Whenever a lost dog is found, the finder is asked to click a picture of the pet whose breed is determined'
                        ' by our face-recogition technology. All the dogs of the same breed are searched within 50km radius of the current location of the finder. The finder then contacts the possible owners of the pets among the list.',
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "We are always open to suggestions. Reach us at:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Linkify(
                      onOpen: _onOpen,
                      textScaleFactor: 2,
                      text: "helpfindpaws@gmail.com",
                      linkStyle: TextStyle(color: mainColor, fontSize: 10),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
