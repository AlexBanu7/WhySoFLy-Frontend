import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {

  final void Function(File) passImage;
  final String? initialImage;

  const ImageInput({Key? key, required this.passImage, this.initialImage}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInput();
}

class _ImageInput extends State<ImageInput> {
  // This is the file that will be used to store the image
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      widget.passImage(File(pickedImage.path));
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(children: [
          Center(
            // this button is used to open the image picker
            child: ElevatedButton(
              onPressed: _openImagePicker,
              child: const Text('Select An Image'),
            ),
          ),
          const SizedBox(height: 35),
          // The picked image will be displayed here
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 300,
            color: Colors.grey[300],
            child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : widget.initialImage != null
                ? Image.memory(
                  base64Decode(widget.initialImage!.split(',').last),
                  height: MediaQuery.of(context).size.height * 0.3,
                )
                : const Text('Please select an image'),
          )
        ]),
      ),
    );
  }
}