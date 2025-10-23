import 'package:logger/logger.dart';
import 'package:atomepet/services/pet_service.dart';
import 'package:atomepet/models/pet.dart';

class PetRepository {
  final PetService _petService;
  final Logger _logger = Logger();

  PetRepository(this._petService);

  Future<Pet> addPet(Pet pet) async {
    try {
      final newPet = await _petService.addPet(pet);
      return newPet;
    } catch (e) {
      _logger.e('Error adding pet: $e');
      rethrow;
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    try {
      final updatedPet = await _petService.updatePet(pet);
      return updatedPet;
    } catch (e) {
      _logger.e('Error updating pet: $e');
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByStatus(List<PetStatus> statuses) async {
    try {
      final pets = await _petService.findPetsByStatus(statuses);
      return pets;
    } catch (e) {
      _logger.e('Error finding pets by status: $e');
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByTags(List<String> tags) async {
    try {
      final pets = await _petService.findPetsByTags(tags);
      return pets;
    } catch (e) {
      _logger.e('Error finding pets by tags: $e');
      rethrow;
    }
  }

  Future<Pet> getPetById(int petId) async {
    try {
      final pet = await _petService.getPetById(petId);
      return pet;
    } catch (e) {
      _logger.e('Error getting pet by id: $e');
      rethrow;
    }
  }

  Future<void> deletePet(int petId, {String? apiKey}) async {
    try {
      await _petService.deletePet(petId, apiKey: apiKey);
    } catch (e) {
      _logger.e('Error deleting pet: $e');
      rethrow;
    }
  }
}
