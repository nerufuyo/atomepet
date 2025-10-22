import 'package:dio/dio.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/api_response.dart';

class PetService {
  final ApiService _apiService;

  PetService(this._apiService);

  Future<Pet> addPet(Pet pet) async {
    try {
      final response = await _apiService.post('/pet', data: pet.toJson());
      return Pet.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    try {
      final response = await _apiService.put('/pet', data: pet.toJson());
      return Pet.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByStatus(List<PetStatus> statuses) async {
    try {
      final statusStrings = statuses.map((s) => s.name).join(',');
      final response = await _apiService.get(
        '/pet/findByStatus',
        queryParameters: {'status': statusStrings},
      );
      return (response.data as List).map((pet) => Pet.fromJson(pet)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Pet>> findPetsByTags(List<String> tags) async {
    try {
      final response = await _apiService.get(
        '/pet/findByTags',
        queryParameters: {'tags': tags.join(',')},
      );
      return (response.data as List).map((pet) => Pet.fromJson(pet)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Pet> getPetById(int petId) async {
    try {
      final response = await _apiService.get('/pet/$petId');
      return Pet.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePetWithForm(
    int petId,
    String? name,
    String? status,
  ) async {
    try {
      await _apiService.post(
        '/pet/$petId',
        queryParameters: {
          if (name != null) 'name': name,
          if (status != null) 'status': status,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePet(int petId, {String? apiKey}) async {
    try {
      await _apiService.delete(
        '/pet/$petId',
        options: Options(headers: apiKey != null ? {'api_key': apiKey} : null),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> uploadFile(
    int petId,
    String filePath, {
    String? additionalMetadata,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        if (additionalMetadata != null)
          'additionalMetadata': additionalMetadata,
      });

      final response = await _apiService.post(
        '/pet/$petId/uploadImage',
        data: formData,
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
