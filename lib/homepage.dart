// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:login_app/auth_with_phone/signin_with_phone.dart';
// import 'home_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController emailcontroller = TextEditingController();

//   void signout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.popUntil(context, (route) => route.isFirst);
//     Navigator.pushReplacement(
//         context, CupertinoPageRoute(builder: (context) => SignInWithPhone()));
//   }

//   void saveUser() {
//     String name = namecontroller.text.trim();
//     String email = emailcontroller.text.trim();
//     namecontroller.clear();
//     emailcontroller.clear();
//     if (name != '' && email != '') {
//       Map<String, dynamic> UserData = {
//         "name": name,
//         "email": email,
//       };
//       FirebaseFirestore.instance.collection("users").add(UserData);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('User saved successfully.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all fields!'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'HomePage',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.lightBlue,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               signout();
//             },
//             icon: const Icon(Icons.exit_to_app_sharp),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: namecontroller,
//                 decoration: const InputDecoration(
//                   hintText: "Name",
//                 ),
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               TextField(
//                 controller: emailcontroller,
//                 decoration: const InputDecoration(
//                   hintText: "Email Address",
//                 ),
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor:
//                       WidgetStateProperty.all<Color>(Colors.lightBlue),
//                   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                   ),
//                 ),
//                 onPressed: () {
//                   saveUser();
//                 },
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 20,
//               ),

//              StreamBuilder<QuerySnapshot>(stream:FirebaseFirestore.instance.collection("users").snapshots()
//                , builder:(context, snapshot)
//                {
//                if(snapshot.connectionState == ConnectionState.active)
//                {
//                 if(snapshot.hasData && snapshot.data !=null)
//                 {
//                   return
//                   ListView.builder(itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context,index)
//                   {
//                    Map<String,dynamic>userMap=  snapshot.data.docs[index].data() as Map<String,dynamic>;

//                    return
//                    Expanded(
//                      child: ListTile(
//                       title: Text(userMap["name"]),
//                       subtitle: Text(userMap["email"]),
//                      ),
//                    );
//                   },);

//                 }
//               else
//               {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('No Data Exist!'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//               }
//                }
//                else {
//                return Center(
//                 child: CircularProgressIndicator(),
//                );
//                }
//                } ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/home_screen.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController agecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  File? profilepic;

  void signout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        CupertinoPageRoute(builder: (context) => const HomeScreen()));
  }

  void saveUser() async {
    String name = namecontroller.text.trim();
    String email = emailcontroller.text.trim();
    String ageString = agecontroller.text.trim();

    int age = int.parse(ageString);

    namecontroller.clear();
    emailcontroller.clear();
    agecontroller.clear();

    if (name != '' && email != '' && profilepic != null) {
      // Start image upload
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilepictures")
          .child(Uuid().v1())
          .putFile(profilepic!);

      StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double percentage =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
      });

      // Wait for upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get download URL
      String downloadurl = await taskSnapshot.ref.getDownloadURL();

      taskSubscription.cancel();

      // Create a map with the user data
      Map<String, dynamic> UserData = {
        "name": name,
        "email": email,
        "age": age,
        "profilepic": downloadurl,
      };

      // Save user data to Firestore
      FirebaseFirestore.instance.collection("users").add(UserData);

      // Clear profilepic variable to reset the UI
      setState(() {
        profilepic = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // void saveUser() async {
  //   String name = namecontroller.text.trim();
  //   String email = emailcontroller.text.trim();
  //   String ageString = agecontroller.text.trim();

  //   int age = int.parse(ageString);

  //   namecontroller.clear();
  //   emailcontroller.clear();
  //   agecontroller.clear();

  //   if (name != '' && email != '' && profilepic != null) {
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref()
  //         .child("profilepictures")
  //         .child(Uuid().v1())
  //         .putFile(profilepic!);
  //     StreamSubscription taskSubscription =
  //         uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double percentage =
  //           snapshot.bytesTransferred / snapshot.totalBytes * 100;
  //     });

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadurl = await taskSnapshot.ref.getDownloadURL();

  //     taskSubscription.cancel();
  //     // ignore: non_constant_identifier_names
  //     Map<String, dynamic> UserData = {
  //       "name": name,
  //       "email": email,
  //       "age": age,
  //       "profilepic": downloadurl,
  //     };
  //     FirebaseFirestore.instance.collection("users").add(UserData);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('User saved successfully.'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please fill in all fields!'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'HomePage',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              signout();
            },
            icon: const Icon(Icons.exit_to_app_sharp),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedimage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedimage != null) {
                    File convertedFile = File(selectedimage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Image Selected!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No Image Selected"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  backgroundImage:
                      (profilepic != null) ? FileImage(profilepic!) : null,
                  radius: 45,
                  backgroundColor: Colors.grey,
                ),
              ),

              TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  hintText: "Email Address",
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: agecontroller,
                decoration: const InputDecoration(
                  hintText: "Age",
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.lightBlue),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                onPressed: () {
                  saveUser();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // StreamBuilder to display the user list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .orderBy('age')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Text('Error fetching data');
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('No Data Exist!');
                    }

                    var userDocs = snapshot.data!.docs;

                    if (userDocs.isEmpty) {
                      return const Text('No users found');
                    }

                    return ListView.builder(
                      itemCount: userDocs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> userMap =
                            userDocs[index].data() as Map<String, dynamic>;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userMap["profilepic"]),
                          ),
                          title: Text(userMap["name"] + "(${userMap["age"]})" ??
                              'No name'),
                          subtitle: Text(userMap["email"] ?? 'No email'),
                          trailing: IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(userDocs[index].id)
                                    .delete();
                              },
                              icon: const Icon(Icons.delete)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
