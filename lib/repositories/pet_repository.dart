import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:atomepet/services/pet_service.dart';
import 'package:atomepet/services/database_service.dart';
import 'package:atomepet/models/pet.dart';

class PetRepository {
  final PetService _petService;
  final DatabaseService _databaseService;
  final Logger _logger = Logger();

  PetRepository(this._petService, this._databaseService);

  Box get _petBox => _databaseService.getBox(DatabaseService.petBox);

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Pet> addPet(Pet pet) async {
    try {
      if (await _isOnline()) {
        final newPet = await _petService.addPet(pet);
        await _petBox.put('pet_${newPet.id}', newPet.toJson());
        return newPet;
      } else {
        throw Exception('No internet connection');
      }
    } catch (e) {
      _logger.e('Error adding pet: $e');
      rethrow;
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    try {
      if (await _isOnline()) {
        final updatedPet = await _petService.updatePet(pet);
        await _petBox.put('pet_${updatedPet.id}', updatedPet.toJson());
        return updatedPet;
      } else {
        await _petBox.put('pending_update_${pet.id}', pet.toJson());
        throw Exception('Offline: Changes will sync when online');
      }
    } catch (e) {
      _logger.e('Error updating pet: $e');
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByStatus(List<PetStatus> statuses) async {
    try {
      if (await _isOnline()) {
        final pets = await _petService.findPetsByStatus(statuses);
        for (var pet in pets) {
          await _petBox.put('pet_${pet.id}', pet.toJson());
        }
        await _petBox.put(
          'cached_pets_by_status',
          pets.map((p) => p.toJson()).toList(),
        );
        return pets;
      } else {
        final cached = _petBox.get('cached_pets_by_status');
        if (cached != null) {
          return (cached as List).map((p) => Pet.fromJson(p)).toList();
        }
        throw Exception('No cached data available');
      }
    } catch (e) {
      _logger.e('Error finding pets by status: $e');
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByTags(List<String> tags) async {
    try {
      if (await _isOnline()) {
        final pets = await _petService.findPetsByTags(tags);
        for (var pet in pets) {
          await _petBox.put('pet_${pet.id}', pet.toJson());
        }
        return pets;
      } else {
        final allPets = _petBox.values
            .where((v) => v is Map && v.containsKey('name'))
            .map((v) => Pet.fromJson(Map<String, dynamic>.from(v)))
            .toList();
        return allPets;
      }
    } catch (e) {
      _logger.e('Error finding pets by tags: $e');
      rethrow;
    }
  }

  Future<Pet> getPetById(int petId) async {
    try {
      if (await _isOnline()) {
        final pet = await _petService.getPetById(petId);
        await _petBox.put('pet_$petId', pet.toJson());
        return pet;
      } else {
        final cached = _petBox.get('pet_$petId');
        if (cached != null) {
          return Pet.fromJson(Map<String, dynamic>.from(cached));
        }
        throw Exception('Pet not found in cache');
      }
    } catch (e) {
      _logger.e('Error getting pet by id: $e');
      rethrow;
    }
  }

  Future<void> deletePet(int petId, {String? apiKey}) async {
    try {
      if (await _isOnline()) {
        await _petService.deletePet(petId, apiKey: apiKey);
        await _petBox.delete('pet_$petId');
      } else {
        await _petBox.put('pending_delete_$petId', true);
        throw Exception('Offline: Deletion will sync when online');
      }
    } catch (e) {
      _logger.e('Error deleting pet: $e');
      rethrow;
    }
  }

  Future<void> syncPendingChanges() async {
    try {
      if (await _isOnline()) {
        final keys = _petBox.keys.toList();
        for (var key in keys) {
          if (key.toString().startsWith('pending_update_')) {
            final petData = _petBox.get(key);
            final pet = Pet.fromJson(Map<String, dynamic>.from(petData));
            await updatePet(pet);
            await _petBox.delete(key);
          } else if (key.toString().startsWith('pending_delete_')) {
            final petId = int.parse(key.toString().split('_').last);
            await deletePet(petId);
            await _petBox.delete(key);
          }
        }
        _logger.i('Pending changes synced successfully');
      }
    } catch (e) {
      _logger.e('Error syncing pending changes: $e');
    }
  }
}
