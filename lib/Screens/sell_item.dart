import 'dart:math';

import 'package:app_1/consts/consts.dart';
import 'package:app_1/models/ProductDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/firebaseHelper.dart';
import '../models/userModel.dart';

Color activeConditionColor = Color.fromARGB(255, 139, 216, 141);
Color inactiveConditionColor = Color.fromARGB(255, 176, 171, 171);

class SellItem extends StatefulWidget {
  final User? firebaseUser;

  SellItem({
    super.key,
    required this.firebaseUser,
  });

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController itemName = TextEditingController();
  String condition = 'used';
  bool clickNew = false;
  bool clickUsed = true;

  Color newColor = activeConditionColor;
  Color usedColor = inactiveConditionColor;

//image and cloud storage section

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String imageUrl = noimageavailable;

  final List<String> _categoryList = <String>[
    "Electronics",
    "Stationary",
    "Grocery",
    "Vehicle"
  ];
  String _category = 'Electronics';

  final List<String> _location = <String>["Kathmandu", "Lalitpur", "Bhaktapur"];
  String _choosedLocation = 'Kathmandu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Item Details',
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 152,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 90,
                              width: 95,
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)),
                              child: _image == null
                                  ? Icon(Icons.cancel)
                                  : Image(
                                      image: XFileImage(_image!),
                                      height: 300,
                                      width: 300,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 95,
                              width: 95,
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                  onPressed: () {
                                    _showImageSourceDialog();
                                  },
                                  icon: Icon(Icons.add)),
                            ),
                          ],
                        ),
                        SizedBox(height: 9),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Item name*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: itemName,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Item name'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Category*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: _category,
                          items: _categoryList
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _category = val.toString();
                            });
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Container(
                  height: 95,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: description,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Description'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Condition*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(newColor)),
                        onPressed: () {
                          if (condition == 'New') {
                            setState(() {
                              condition = 'New';
                              newColor = activeConditionColor;
                              usedColor = inactiveConditionColor;
                            });
                          } else {
                            setState(() {
                              condition = 'New';
                              newColor = activeConditionColor;
                              usedColor = inactiveConditionColor;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'New',
                            style: TextStyle(
                              color: (clickNew == true)
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(usedColor),
                        ),
                        onPressed: () {
                          if (condition == 'New') {
                            setState(() {
                              condition = 'Used';
                              usedColor = activeConditionColor;
                              newColor = inactiveConditionColor;
                            });
                          } else {
                            setState(() {
                              condition = 'Used';
                              usedColor = activeConditionColor;
                              newColor = inactiveConditionColor;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Used',
                            style: TextStyle(
                              color: (clickUsed == false)
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 16),
                Text('Price*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: price,
                      decoration: InputDecoration.collapsed(hintText: 'Price'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Location*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: _choosedLocation,
                          items: _location
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _choosedLocation = val.toString();
                            });
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () async {
// first sending image to firebase storage

                        if (_image == null) return;
                        //getting reference to storage root
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        //reference for the images to be stored
                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        //Store the file
                        try {
                          await referenceImageToUpload
                              .putFile(File(_image!.path));

                          //get the url of the image
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to Upload Image :$error"),
                            ),
                          );
                        }

// Products Section
                        Random random = Random.secure();
                        String? pid = random.nextInt(5000).toString();
                        UserModel? SellerName =
                            await FirebaseHelper.getUserModelById(
                                widget.firebaseUser!.uid);
                        // String? uid = widget.firebaseUser?.uid;
                        Products productModel = Products(
                          ProductSellerName: SellerName!.fullname,
                          ProductImage: imageUrl,
                          ProductName: itemName.text.toString(),
                          ProductCategory: _category,
                          ProductDescription: description.text.toString(),
                          ItemCondition: condition,
                          ProductPrice: price.text.toString(),
                          ListedLocation: _choosedLocation,
                          ProductSellerID: widget.firebaseUser?.uid,
                          ProductID: pid,
                          ListedDate: DateTime.now().toString(),
                        );

                        await FirebaseFirestore.instance
                            .collection('Products')
                            //.doc(uid)
                            //.collection('Items')
                            .doc(pid)
                            .set(productModel.toMap())
                            .then((value) => 'Product added successfully');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Item Added Succesfully"),
                          ),
                        );
                      },
                      child: const Center(
                          child: Text('Post Now',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              )))),
                )
              ],
            ),
          ),
        ));
  }

  _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    _openCamera();
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _openGallery();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _openCamera() async {
    XFile? image;
    image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _openGallery() async {
    XFile? image;
    image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // ignore: unused_element
  _sendImageCloud() async {
    if (_image == null) return;
    //getting reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //reference for the images to be stored
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Store the file
    try {
      await referenceImageToUpload.putFile(File(_image!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      print(error);
    }
  }
}
