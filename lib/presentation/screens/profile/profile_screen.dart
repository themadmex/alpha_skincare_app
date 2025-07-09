// lib/presentation/screens/profile/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../providers/profile_provider.dart';
import '../../../domain/entities/profile.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();

  String _selectedGender = '';
  String _selectedSkinType = '';
  List<String> _selectedConcerns = [];

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _skinTypes = ['Oily', 'Dry', 'Combination', 'Normal', 'Sensitive'];
  final List<String> _skinConcerns = [
    'Acne',
    'Dark Spots',
    'Wrinkles',
    'Dryness',
    'Oiliness',
    'Sensitivity',
    'Pores',
    'Dullness',
    'Uneven Tone',
    'Redness',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate() && _selectedGender.isNotEmpty && _selectedSkinType.isNotEmpty) {
      final profile = UserProfile(
        id: '',
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        skinType: _selectedSkinType,
        skinConcerns: _selectedConcerns,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await ref.read(profileControllerProvider.notifier).updateProfile(profile);
        context.go('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This helps us provide personalized skincare recommendations',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Age
                CustomTextField(
                  controller: _ageController,
                  label: 'Age',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 100) {
                      return 'Please enter a valid age (13-100)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Gender
                _buildSectionTitle('Gender'),
                _buildChipSelection(
                  options: _genders,
                  selectedValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Skin Type
                _buildSectionTitle('Skin Type'),
                const Text(
                  'Not sure? Take our skin analysis after setup!',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildChipSelection(
                  options: _skinTypes,
                  selectedValue: _selectedSkinType,
                  onChanged: (value) {
                    setState(() {
                      _selectedSkinType = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Skin Concerns
                _buildSectionTitle('Skin Concerns (Optional)'),
                const Text(
                  'Select all that apply',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildMultiChipSelection(
                  options: _skinConcerns,
                  selectedValues: _selectedConcerns,
                  onChanged: (values) {
                    setState(() {
                      _selectedConcerns = values;
                    });
                  },
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Complete Setup',
                  onPressed: (_selectedGender.isNotEmpty &&
                      _selectedSkinType.isNotEmpty &&
                      !profileState.isLoading)
                      ? _saveProfile
                      : null,
                  isLoading: profileState.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildChipSelection({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onChanged(option);
            }
          },
          backgroundColor: Colors.grey.withOpacity(0.1),
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildMultiChipSelection({
    required List<String> options,
    required List<String> selectedValues,
    required Function(List<String>) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            final newValues = List<String>.from(selectedValues);
            if (selected) {
              newValues.add(option);
            } else {
              newValues.remove(option);
            }
            onChanged(newValues);
          },
          backgroundColor: Colors.grey.withOpacity(0.1),
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }
}
