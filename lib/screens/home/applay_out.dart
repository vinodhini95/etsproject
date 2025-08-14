
import 'package:ets/provider/json_data_provider.dart';
import 'package:ets/screens/dynamic_form/dynamic_formfield.dart';
import 'package:ets/screens/home/profile_page.dart';
import 'package:ets/utils/assets.dart';
import 'package:ets/utils/color.dart';
import 'package:ets/utils/localization.dart';
import 'package:ets/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';


class CardHome extends StatefulWidget {
  const CardHome({super.key});

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  bool isLoading = true;
  String userName = "";
  String userEmail = "";
  int selectedIndex = 0;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    
    await Provider.of<JsonDataProvider>(context, listen: false)
        .loadJsonData('assets/json/home_screen.json', context);
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = <Widget>[
      buildHomeScreen(context),
      // ProcessSummaryScreen(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
                                    .translate(StringData.APP_NAME) ??
                                '',
          style: TextStyle(color: whiteButtonColor),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(
          padding: EdgeInsets.only(left: 17),
          child: Image.asset(Assets.APP_LOGO),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              color: Colors.white,
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: buildDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
              image: AssetImage('assets/images/cashew2.png'),

              // fit: BoxFit.fitHeight,
            ))),
          ),
          Container(
            color: Colors.white.withOpacity(0.80),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/300/300",
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.logout, color: Theme.of(context).primaryColor),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                 
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber,
      unselectedItemColor: whiteButtonColor,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget buildHomeScreen(BuildContext context) {
    var detailData = context.read<JsonDataProvider>().totalData;
    return  Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            if (detailData["children"] != null)
              DynamicFormFieldBuilder(
                fieldData: detailData["children"],
                formKey: formKey,
              ),
          ],
        ),
      );
  }
}
