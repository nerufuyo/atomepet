import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/category.dart';
import 'package:atomepet/models/tag.dart';
import 'package:atomepet/views/widgets/app_text_field.dart';
import 'package:atomepet/views/widgets/app_button.dart';

class PetFormScreen extends StatefulWidget {
  final Pet? pet;

  const PetFormScreen({super.key, this.pet});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _tagNameController = TextEditingController();

  final _photoUrls = <String>[].obs;
  final _tags = <Tag>[].obs;
  PetStatus _selectedStatus = PetStatus.available;

  bool get isEditMode => widget.pet != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final pet = widget.pet!;
    _nameController.text = pet.name ?? '';
    _selectedStatus = pet.status ?? PetStatus.available;

    if (pet.category != null) {
      _categoryIdController.text = pet.category!.id?.toString() ?? '';
      _categoryNameController.text = pet.category!.name ?? '';
    }

    _photoUrls.value = List.from(pet.photoUrls ?? []);
    if (pet.tags != null) {
      _tags.value = List.from(pet.tags!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryIdController.dispose();
    _categoryNameController.dispose();
    _photoUrlController.dispose();
    _tagNameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter pet name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhotoUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!Uri.tryParse(value)!.hasAbsolutePath) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  void _addPhotoUrl() {
    if (_photoUrlController.text.isNotEmpty) {
      final error = _validatePhotoUrl(_photoUrlController.text);
      if (error == null) {
        _photoUrls.add(_photoUrlController.text);
        _photoUrlController.clear();
      } else {
        Get.snackbar('Invalid URL', error, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _removePhotoUrl(int index) {
    _photoUrls.removeAt(index);
  }

  void _addTag() {
    if (_tagNameController.text.isNotEmpty) {
      final newTag = Tag(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _tagNameController.text,
      );
      _tags.add(newTag);
      _tagNameController.clear();
    }
  }

  void _removeTag(int index) {
    _tags.removeAt(index);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_photoUrls.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one photo URL',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final controller = Get.find<PetController>();

    Category? category;
    if (_categoryNameController.text.isNotEmpty) {
      category = Category(
        id: _categoryIdController.text.isNotEmpty
            ? int.tryParse(_categoryIdController.text)
            : null,
        name: _categoryNameController.text,
      );
    }

    final pet = Pet(
      id: isEditMode ? widget.pet!.id : null,
      name: _nameController.text,
      category: category,
      photoUrls: _photoUrls.toList(),
      tags: _tags.isEmpty ? null : _tags.toList(),
      status: _selectedStatus,
    );

    if (isEditMode) {
      await controller.updatePet(pet);
    } else {
      await controller.addPet(pet);
    }

    if (controller.error.value.isEmpty) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Pet' : 'Add New Pet'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pet Name
                  Text(
                    'Pet Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFieldContainer(
                    theme,
                    AppTextField(
                      controller: _nameController,
                      label: 'Pet Name',
                      hint: 'Enter pet name',
                      prefixIcon: Icons.pets,
                      validator: _validateName,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  _buildFieldContainer(
                    theme,
                    DropdownButtonFormField<PetStatus>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.check_circle_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      items: PetStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category Section
                  Text(
                    'Category',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildFieldContainer(
                          theme,
                          AppTextField(
                            controller: _categoryIdController,
                            label: 'Category ID',
                            hint: 'Optional',
                            prefixIcon: Icons.tag,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildFieldContainer(
                          theme,
                          AppTextField(
                            controller: _categoryNameController,
                            label: 'Category Name',
                            hint: 'e.g., Dogs, Cats',
                            prefixIcon: Icons.category,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Photo URLs Section
                  Text(
                    'Photo URLs',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFieldContainer(
                          theme,
                          AppTextField(
                            controller: _photoUrlController,
                            label: 'Photo URL',
                            hint: 'https://example.com/image.jpg',
                            prefixIcon: Icons.image,
                            validator: _validatePhotoUrl,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _addPhotoUrl(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _addPhotoUrl,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => _photoUrls.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              'No photos added yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _photoUrls
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Chip(
                                    avatar: const Icon(Icons.image, size: 18),
                                    label: Text(
                                      'Photo ${entry.key + 1}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    deleteIcon: const Icon(Icons.close, size: 18),
                                    onDeleted: () => _removePhotoUrl(entry.key),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Tags Section
                  Text(
                    'Tags',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFieldContainer(
                          theme,
                          AppTextField(
                            controller: _tagNameController,
                            label: 'Tag Name',
                            hint: 'e.g., Friendly, Active',
                            prefixIcon: Icons.label,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _addTag,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => _tags.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              'No tags added yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tags
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Chip(
                                    label: Text(entry.value.name ?? ''),
                                    deleteIcon: const Icon(Icons.close, size: 18),
                                    onDeleted: () => _removeTag(entry.key),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  Obx(
                    () => Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: AppButton(
                        text: isEditMode ? 'Update Pet' : 'Create Pet',
                        onPressed: _handleSave,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel Button
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer(ThemeData theme, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
