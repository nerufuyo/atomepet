import 'package:get/get.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/repositories/pet_repository.dart';

class PetController extends GetxController {
  final PetRepository _petRepository;

  PetController(this._petRepository);

  final RxList<Pet> pets = <Pet>[].obs;
  final RxList<Pet> filteredPets = <Pet>[].obs;
  final Rx<Pet?> selectedPet = Rx<Pet?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<PetStatus> selectedStatus = PetStatus.available.obs;
  final RxString searchQuery = ''.obs;

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
      filteredPets.value = result;
      _applySearch();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredPets.value = pets;
    } else {
      filteredPets.value = pets.where((pet) {
        final name = pet.name?.toLowerCase() ?? '';
        final category = pet.category?.name?.toLowerCase() ?? '';
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    }
  }
}
