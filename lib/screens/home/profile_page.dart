
import 'package:ets/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String factoryName = "";
  String unitName = "";

  @override
  void initState() {
    super.initState();
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: profilePhotos(),
                      ),
                      profileName("Employee", factoryName, unitName),
                    ],
                  ),
                  contactSection({
                    "mobile":"968767654",
                    "email":"test@gmail.com",
                    "status":"Active"
                  }),
                ],
              ),
            )
          );
    // FutureBuilder<dynamic>(
    //   future: LocalProvider().getLocalStorageAsObject("user_data"),
    //   builder: (BuildContext context,
    //       AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     } else if (!snapshot.hasData || snapshot.data == null) {
    //       return Text('No user found');
    //     } else {
    //       Map<String, dynamic> user = snapshot.data!;
    //       return ;
    //     }
    //   },
    // );
  }

  Padding hobbies() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Text(
        "Traveller - Dreamer - Fighter",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget profileName(String userName, String factoryName, String unitName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Row stats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "Photos",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "160",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Followers",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "1657",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Following",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "9",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }

  Container profilePhotos() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.red,
      ),
      width: 105,
      height: 105,
      alignment: Alignment.center,
      child: const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          "https://picsum.photos/300/300",
        ),
      ),
    );
  }

  Column contactSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contactDetail(data["mobile_number"] ?? "", data["email"] ?? "",
            data["_id"] ?? "DEMO123", data["status"]),
        // contactStatus(data["status"]),
      ],
    );
  }

  Widget contactDetail(
      String mobileNumber, String emailId, String empId, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          color: Colors.white,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.phone_android, color: Theme.of(context).primaryColor),
            title: Text(
              "Mobile",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: greyColor),
            ),
            subtitle: Text(
              mobileNumber,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: BlackColor),
            ),
          ),
        ),
        Card(
          margin:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          color: Colors.white,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.mail, color: Theme.of(context).primaryColor),
            title: Text(
              "Email",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: greyColor),
            ),
            subtitle: Text(
              emailId,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: BlackColor),
            ),
          ),
        ),
        Card(
          margin:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          color: Colors.white,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.web_asset, color: Theme.of(context).primaryColor),
            title: Text(
              "User Id",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: greyColor),
            ),
            subtitle: Text(
              empId,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: BlackColor),
            ),
          ),
        ),
        Card(
          margin:
              const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
                radius: 14,
                backgroundColor:
                    status == "Active" ? Theme.of(context).colorScheme.primary : whiteButtonColor,
                child: Icon(status == "Active" ? Icons.check : Icons.clear,
                    color: status == "Active" ? whiteButtonColor : Colors.red)),
            iconColor: whiteButtonColor,
            textColor: Colors.grey,
            title: Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              status == "Active" ? "Active" : "InActive",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: BlackColor),
            ),
            dense: true,
          ),
        ),
      ],
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
