import 'package:bestlocaleats/utils/colors.dart';
import 'package:bestlocaleats/utils/constants.dart';
import 'package:bestlocaleats/utils/router.dart';
import 'package:bestlocaleats/widgets/top_bar.dart';
import 'package:bestlocaleats/widgets/drawer.dart';
import 'package:bestlocaleats/widgets/bottom_bar.dart';
import 'package:bestlocaleats/widgets/responsive.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const numberOfItems = 20;
const minItemHeight = 200.0;
const maxItemHeight = 350.0;
const scrollDuration = Duration(seconds: 2);

class AllRestaurantPage extends StatefulWidget {
  const AllRestaurantPage({super.key});

  @override
  State<AllRestaurantPage> createState() => _AllRestaurantPageState();
}

class _AllRestaurantPageState extends State<AllRestaurantPage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Controller to scroll a certain number of pixels relative to the current
  /// scroll offset.
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late List<double> itemHeights;

  late int categoryItemIndex = 0;

  @override
  void initState() {
    final heightGenerator = Random(328902348);
    itemHeights = List<double>.generate(
        numberOfItems,
        (int _) =>
            heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) +
            minItemHeight);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double brandWidth = (screenSize.width - Constants.mainPadding * 4) / 3;
    if (screenSize.width < 1100) {
      brandWidth = 300;
    }
    if (screenSize.width < 650) {
      brandWidth = screenSize.width / 2;
    }

    return Scaffold(
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              // for smaller screen sizes
              backgroundColor: Colors.blueGrey[900]?.withOpacity(1),
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
              child: const TopBarContents(1, 1),
            ),
      drawer: const MobileDrawer(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 4, vertical: 50),
              child: Stack(
                children: [
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                            color: CustomColor.primaryColor.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 0)),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Search for your favorite foods & restaurants',
                        prefixIcon: Icon(Icons.search,
                            color: CustomColor.textSecondaryColor, size: 24)),
                  ),
                ],
              )),
          SizedBox(
            width: screenSize.width,
            height: 120,
            child: OrientationBuilder(
              builder: (context, orientation) => Column(
                children: <Widget>[
                  scrollControlButtons,
                  Expanded(
                    child: list(orientation),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.mainPadding, vertical: 10),
            child: Row(children: [
              SizedBox(
                width: brandWidth,
                child: const Text('Top Brands',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Expanded(
                child: Text('Best offers for you',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
          SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Row(children: [
                SizedBox(
                  width: brandWidth,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.mainPadding / 2),
                      child: _topBrands()),
                ),
                Container(
                  width: 1,
                  color: Colors.black,
                ),
                Expanded(child: _bestOffers())
              ])),
          const BottomBar(),
        ]),
      ),
    );
  }

  Widget list(Orientation orientation) => ScrollablePositionedList.builder(
        itemCount: numberOfItems,
        itemBuilder: (context, index) => item(index, orientation),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetController: scrollOffsetController,
        reverse: false,
        scrollDirection: orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal,
      );

  Widget get scrollControlButtons => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.mainPadding, vertical: 10),
        child: Row(children: [
          const Text('Categories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Spacer(),
          scrollItemButton(categoryItemIndex - 1, true),
          scrollItemButton(categoryItemIndex + 1, false),
        ]),
      );

  ButtonStyle _scrollButtonStyle({required double horizonalPadding}) =>
      ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: horizonalPadding, vertical: 0),
        ),
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  Widget scrollItemButton(int value, bool back) => TextButton(
        key: ValueKey<String>('Scroll$value'),
        onPressed: () {
          if (back && value < 0) return;
          if (!back && value > numberOfItems - 1) return;
          if (back && value > 0) {
            setState(() {
              categoryItemIndex = categoryItemIndex - 1;
            });
          }
          if (!back && value < numberOfItems - 1) {
            setState(() {
              categoryItemIndex = categoryItemIndex + 1;
            });
          }
          scrollTo(value);
        },
        style: _scrollButtonStyle(horizonalPadding: 10),
        child: back
            ? const Icon(Icons.arrow_back,
                size: 20, color: CustomColor.activeColor)
            : const Icon(Icons.arrow_forward,
                size: 20, color: CustomColor.activeColor),
      );

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: 0);

  Widget item(int i, Orientation orientation) {
    double itemWidth = 0;
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width > 0) itemWidth = screenSize.width / 2;
    if (screenSize.width > 500) itemWidth = screenSize.width / 3;
    if (screenSize.width > 700) itemWidth = screenSize.width / 4;
    if (screenSize.width > 900) itemWidth = screenSize.width / 5;
    if (screenSize.width > 1100) itemWidth = screenSize.width / 6;
    return SizedBox(
      height: orientation == Orientation.portrait ? itemHeights[i] : null,
      width: orientation == Orientation.landscape ? itemWidth : null,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.mainPadding, vertical: 10),
          child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 2, color: Colors.black),
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadowColor: CustomColor.primaryColor.withOpacity(0.5),
                    padding: const EdgeInsets.all(5)),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 2),
                    Image.asset(
                      Constants.IMG_COFFEECUP,
                      width: 25,
                    ),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 40, color: Colors.black),
                    const SizedBox(width: 8),
                    const Text(
                      'Coffee',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColor.textSecondaryColor),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _topBrands() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (_, int index) {
          return brandBox('Mc Donald\'S', 0);
        });
  }

  Widget brandBox(String title, int index) {
    List<double> sizes = [
      Constants.mainPadding / 2,
      12,
      12,
      12,
      130,
      100,
      30,
      18,
      16,
      14
    ];
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 1300) {
      sizes = [Constants.mainPadding / 2, 12, 12, 12, 110, 80, 20, 16, 14, 12];
    }
    if (screenSize.width < 1140) {
      sizes = [Constants.mainPadding / 2, 12, 12, 12, 90, 70, 10, 14, 12, 10];
    }
    if (screenSize.width < 650) {
      sizes = [Constants.mainPadding / 2, 12, 8, 8, 90, 0, 10, 14, 12, 10];
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sizes[0], vertical: sizes[1]),
      padding: EdgeInsets.symmetric(vertical: sizes[2], horizontal: sizes[3]),
      height: sizes[4],
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: CustomColor.primaryColor.withOpacity(0.2),
            blurRadius: 8.0,
          ),
        ],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: sizes[5],
              child: Image.asset(
                Constants.IMG_GROUP,
                fit: BoxFit.cover,
              )),
          SizedBox(width: sizes[6]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Mc Donald\'S',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: sizes[7])),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(Constants.SVG_DISH),
                  const SizedBox(width: 5),
                  Text(
                    'Burger',
                    style: TextStyle(
                      fontSize: sizes[9],
                      color: CustomColor.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.location_on,
                    color: CustomColor.activeColor,
                    size: sizes[8],
                  ),
                  Text(
                    '1.2km',
                    style: TextStyle(
                      fontSize: sizes[9],
                      color: CustomColor.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CustomColor.activeColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '4.8',
                          style: TextStyle(
                              color: Colors.white, fontSize: sizes[9]),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: sizes[9],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: sizes[6],
                  ),
                  Icon(
                    Icons.access_time,
                    size: sizes[8],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '10min',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: sizes[9],
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
    );
  }

  Widget _bestOffers() {
    Size screenSize = MediaQuery.of(context).size;
    double cardWidth = (screenSize.width - Constants.mainPadding * 5) / 4;
    if (screenSize.width < 1200) {
      cardWidth = screenSize.width * 0.28;
    }
    if (screenSize.width < 920) {
      cardWidth = screenSize.width * 0.2;
    }

    List<double> sizes = [20, 18, 14];
    if (screenSize.width < 650) {
      sizes = [16, 14, 12];
    }
    if (screenSize.width < 550) {
      sizes = [14, 12, 10];
    }

    Widget widget = Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: Constants.mainPadding / 2),
      child: Stack(children: [
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () {
            NavigationRouter.switchToAboutPage(context);
          },
          onHover: (value) {},
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: CustomColor.primaryColor.withOpacity(0.2),
            elevation: 8,
            margin: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
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
                            style: TextStyle(
                                fontSize: sizes[0],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'demo.restaurant.com',
                            style: TextStyle(
                                fontSize: sizes[2],
                                color: CustomColor.textSecondaryColor),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CustomColor.activeColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '4.5',
                              style: TextStyle(
                                  color: Colors.white, fontSize: sizes[2]),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: sizes[2],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
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
                            style: TextStyle(
                                fontSize: sizes[0],
                                color: CustomColor.activeColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'UPTO \$100',
                            style: TextStyle(
                                fontSize: sizes[1],
                                color: CustomColor.textSecondaryColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: CustomColor.activeColor,
                              size: sizes[2],
                            ),
                            Text(
                              '1.2km',
                              style: TextStyle(
                                  fontSize: sizes[2],
                                  color: CustomColor.textSecondaryColor),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.access_time,
                              size: sizes[2],
                              color: CustomColor.textSecondaryColor,
                            ),
                            Text(
                              '10min',
                              style: TextStyle(
                                  fontSize: sizes[2],
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

    List<Widget> list = [];
    if (screenSize.width < 920) {
      for (var i = 0; i < 20; i++) {
        list.add(Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.mainPadding / 2, vertical: 14),
          child: widget,
        ));
      }
    } else {
      for (var i = 0; i < 10; i++) {
        list.add(Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.mainPadding / 2, vertical: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [widget, widget]),
        ));
      }
    }

    return ListView(children: list);
  }
}
