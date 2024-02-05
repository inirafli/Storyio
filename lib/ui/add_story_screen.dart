import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../preferences/auth_preferences.dart';
import '../provider/story_provider.dart';
import '../widgets/add_action_button_widget.dart';
import '../widgets/add_desc_text_field_widget.dart';
import '../widgets/add_image_container_widget.dart';
import '../widgets/custom_action_button_widget.dart';
import '../widgets/float_back_widget.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() onHome;

  const AddStoryScreen({Key? key, required this.onHome}) : super(key: key);

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;
  String _userToken = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthPreferences.getUserData();
    setState(() {
      _userToken = user.token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ImageContainer(pickedImage: _pickedImage),
                const SizedBox(height: 32.0),
                ActionButtons(
                  onCameraView: _onCameraView,
                  onGalleryView: _onGalleryView,
                ),
                const SizedBox(height: 32.0),
                DescriptionTextField(controller: _descriptionController),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoryProvider>(
          builder: (context, storyProvider, child) {
            return CustomActionButton(
              onPressed: () async {
                final token = _userToken;
                final description = _descriptionController.text;

                if (_pickedImage != null) {
                  await storyProvider.addNewStory(token, description, _pickedImage!);

                  if (storyProvider.addStoryState == ResultState.error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            storyProvider.addStoryErrorMessage ?? 'An error occurred',
                          ),
                        ),
                      );
                    }
                  } else if (storyProvider.addStoryState == ResultState.done) {
                    widget.onHome();
                  }
                }
              },
              buttonText: 'Add Story',
              state: storyProvider.addStoryState,
            );
          },
        ),
      ),
    );
  }

  _onCameraView() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  _onGalleryView() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }
}
