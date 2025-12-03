import 'dart:io';

import 'package:cookmate/providers/user_meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/numbered_list_input.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});

  @override
  ConsumerState<AddMealScreen> createState() => _AddNewMealState();
}

class _AddNewMealState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  late ImagePicker imagePicker;
  late TextEditingController nameController;
  late TextEditingController ingredientsController;
  late TextEditingController stepsController;
  late TextEditingController priceController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    nameController = TextEditingController();
    ingredientsController = TextEditingController();
    stepsController = TextEditingController();
    priceController = TextEditingController();
    timeController = TextEditingController();
  }

  chooseImage() async {
    XFile? selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      image = File(selectedImage.path);
      setState(() {});
    }
  }

  captureImage() async {
    XFile? selectedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (selectedImage != null) {
      image = File(selectedImage.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Colors.grey.shade600,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  child: image == null
                      ? const Icon(Icons.image_outlined, size: 150)
                      : Image.file(image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const Icon(Icons.image, size: 30),
                    onTap: () {
                      chooseImage();
                    },
                  ),
                  const VerticalDivider(),
                  InkWell(
                    child: const Icon(Icons.camera, size: 30),
                    onTap: () {
                      captureImage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Meal Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal name.';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time (min)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a time.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              NumberedListInput(
                controller: ingredientsController,
                label: 'Ingredients',
              ),
              const SizedBox(height: 20),
              NumberedListInput(controller: stepsController, label: 'Steps'),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final imagePath = image == null
                            ? 'https://www.pngmart.com/files/16/Kitchen-Chef-Vector-PNG-Transparent-Image.png'
                            : image!.path;
                        final ingredientsList = ingredientsController.text
                            .split('\n')
                            .where((line) => line.trim().isNotEmpty)
                            .map(
                              (line) =>
                                  line.replaceAll(RegExp(r'^\d+\.\s*'), ''),
                            )
                            .toList();

                        final stepsList = stepsController.text
                            .split('\n')
                            .where((line) => line.trim().isNotEmpty)
                            .map(
                              (line) =>
                                  line.replaceAll(RegExp(r'^\d+\.\s*'), ''),
                            )
                            .toList();
                        ref
                            .read(userMealsProvider.notifier)
                            .addMeal(
                              name: nameController.text,
                              image: imagePath,
                              time: timeController.text,
                              price: priceController.text,
                              ingredients: ingredientsList,
                              steps: stepsList,
                            );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(' Save '),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
