import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/repositories/pet_repository.dart';

class PetController extends GetxController {
  final PetRepository _petRepository;

  PetController(this._petRepository);

  final RxList<Pet> pets = <Pet>[].obs;
  final Rx<Pet?> selectedPet = Rx<Pet?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<PetStatus> selectedStatus = PetStatus.available.obs;
  final RxString searchQuery = ''.obs;

  // Computed property - automatically updates when pets or searchQuery change
  List<Pet> get filteredPets {
    if (searchQuery.value.isEmpty) {
      return pets;
    }
    return pets.where((pet) {
      final name = pet.name?.toLowerCase() ?? '';
      final category = pet.category?.name?.toLowerCase() ?? '';
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPetsByStatus([PetStatus.available]);
  }

  Future<void> fetchPetsByStatus(List<PetStatus> statuses) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _petRepository.findPetsByStatus(statuses);
      pets.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPetsByTags(List<String> tags) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _petRepository.findPetsByTags(tags);
      pets.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPetById(int petId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _petRepository.getPetById(petId);
      selectedPet.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPet(Pet pet) async {
    try {
      isLoading.value = true;
      error.value = '';
      final newPet = await _petRepository.addPet(pet);
      pets.add(newPet);
      Get.snackbar(
        'success'.tr,
        'Pet added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.check_circle),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePet(Pet pet) async {
    try {
      isLoading.value = true;
      error.value = '';
      final updatedPet = await _petRepository.updatePet(pet);
      final index = pets.indexWhere((p) => p.id == updatedPet.id);
      if (index != -1) {
        pets[index] = updatedPet;
      }
      selectedPet.value = updatedPet;
      Get.snackbar(
        'success'.tr,
        'Pet updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.check_circle),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePet(int petId, {String? apiKey}) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _petRepository.deletePet(petId, apiKey: apiKey);
      pets.removeWhere((p) => p.id == petId);
      if (selectedPet.value?.id == petId) {
        selectedPet.value = null;
      }
      Get.snackbar(
        'success'.tr,
        'Pet deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.check_circle),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        icon: const Icon(Icons.error_outline),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectPet(Pet pet) {
    selectedPet.value = pet;
  }

  void clearSelectedPet() {
    selectedPet.value = null;
  }

  void filterByStatus(PetStatus status) {
    selectedStatus.value = status;
    fetchPetsByStatus([status]);
  }

  void clearError() {
    error.value = '';
  }

  void searchPets(String query) {
    searchQuery.value = query;
    // filteredPets getter will automatically update
  }
}
