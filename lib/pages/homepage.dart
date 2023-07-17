import 'package:bestlocaleats/utils/colors.dart';
import 'package:bestlocaleats/utils/constants.dart';
import 'package:bestlocaleats/widgets/top_bar.dart';
import 'package:bestlocaleats/widgets/drawer.dart';
import 'package:bestlocaleats/widgets/bottom_bar.dart';
import 'package:bestlocaleats/widgets/responsive.dart';
import 'package:bestlocaleats/widgets/logos.dart';
import 'package:bestlocaleats/widgets/download.dart';
import 'package:bestlocaleats/widgets/contact.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  static double _scrollPosition = 0;
  static double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition == 0 ? 0 : 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              // for smaller screen sizes
              backgroundColor: Colors.blueGrey[900]?.withOpacity(_opacity),
              elevation: 0,
              title: Text(
                'EXPLORE',
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            )
          : PreferredSize(
              // for larger & medium screen sizes
              preferredSize: Size(screenSize.width, 1000),
              child: TopBarContents(_opacity, 1),
            ),
      drawer: MobileDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(children: [
          Stack(
            children: [
              Container(
                // image below the top bar
                child: SizedBox(
                  height: screenSize.height * 0.45,
                  width: screenSize.width,
                  child: Image.asset(
                    'assets/images/cover.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.40,
                    left: screenSize.width / 5,
                    right: screenSize.width / 5,
                  ),
                  child: Card(// floating quick access bar
                      // ...
                      ),
                ),
              )
            ],
          ),
          const ContactSection(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.mainPadding, vertical: 40),
            child: Row(children: [
              const Text('Top Brands Near You', style: TextStyle(fontSize: 24)),
              const Spacer(),
              InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: const Text('See All',
                      style: TextStyle(color: CustomColor.activeColor))),
              InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: const Icon(Icons.arrow_forward,
                      size: 20, color: CustomColor.activeColor)),
            ]),
          ),
          _topBrands(),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.mainPadding, vertical: 40),
            child: Row(children: [
              const Text('Best offers for you', style: TextStyle(fontSize: 24)),
              const Spacer(),
              InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: const Text('See All',
                      style: TextStyle(color: CustomColor.activeColor))),
              InkWell(
                  onHover: (value) {},
                  onTap: () {},
                  child: const Icon(Icons.arrow_forward,
                      size: 20, color: CustomColor.activeColor)),
            ]),
          ),
          _bestOffers(),
          const SizedBox(height: 40),
          const DownloadSection(),
          const LogosSection(),
          const BottomBar(),
        ]),
      ),
    );
  }

  Widget _topBrands() {
    return SizedBox(
      height: 130,
      child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constants.mainPadding / 2),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            brandBox('Mc Donald\'S', 0),
            brandBox('Mc Donald\'S', 0),
            brandBox('Mc Donald\'S', 0),
          ])),
    );
  }

  Widget brandBox(String title, int index) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Constants.mainPadding / 2, vertical: 12),
      padding: const EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: CustomColor.primaryColor.withOpacity(0.2),
            blurRadius: 8.0,
          ),
        ],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Image.asset(
                Constants.IMG_GROUP,
                fit: BoxFit.cover,
              )),
          const SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Mc Donald\'S'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(Constants.SVG_DISH),
                  const Text(
                    'Burger',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.location_on,
                    color: CustomColor.activeColor,
                    size: 12,
                  ),
                  const Text(
                    '1.2km',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: CustomColor.activeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          '5.3',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 12,
                  ),
                  const Text(
                    '10min',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.bookmark,
            color: CustomColor.activeColor,
          ),
        ],
      ),
    ));
  }

  Widget _bestOffers() {
    Widget widget = SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: CustomColor.primaryColor.withOpacity(0.2),
          elevation: 8,
          margin: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alro Business',
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'demo.restaurant.com',
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: CustomColor.textSecondaryColor),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: CustomColor.activeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '4.5',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '50% OFF',
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: CustomColor.activeColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'UPTO \$100',
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: CustomColor.textSecondaryColor),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: CustomColor.activeColor,
                            size: 10,
                          ),
                          Text(
                            '1.2km',
                            style: TextStyle(
                                fontSize: 10.0,
                                color: CustomColor.textSecondaryColor),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.access_time,
                            size: 10,
                            color: CustomColor.textSecondaryColor,
                          ),
                          Text(
                            '10min',
                            style: TextStyle(
                                fontSize: 10.0,
                                color: CustomColor.textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Positioned(
            right: 10,
            top: 10,
            child: Icon(
              Icons.bookmark,
              color: CustomColor.activeColor,
            ))
      ]),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.mainPadding),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child: widget),
        Expanded(child: widget),
        Expanded(child: widget),
        Expanded(child: widget),
      ]),
    );
  }
}
