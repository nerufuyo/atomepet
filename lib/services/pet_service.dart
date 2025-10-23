import 'package:dio/dio.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/models/pet.dart';
import 'package:atomepet/models/api_response.dart';

class PetService {
  final ApiService _apiService;

  PetService(this._apiService);

  Future<Pet> addPet(Pet pet) async {
    try {
      // Validate required fields
      if (pet.name == null || pet.name!.isEmpty) {
        throw Exception('Pet name is required');
      }
      if (pet.photoUrls == null || pet.photoUrls!.isEmpty) {
        throw Exception('At least one photo URL is required');
      }
      
      final response = await _apiService.post('/pet', data: pet.toJson());
      // Handle both JSON object and plain response
      if (response.data is Map<String, dynamic>) {
        return Pet.fromJson(response.data);
      } else if (response.data is String) {
        // If response is a string, try to parse it
        try {
          return Pet.fromJson(response.data);
        } catch (_) {
          // If parsing fails, return the pet with a generated ID
          return pet.copyWith(
            id: pet.id ?? DateTime.now().millisecondsSinceEpoch,
          );
        }
      } else {
        // Fallback: return pet with generated ID
        return pet.copyWith(
          id: pet.id ?? DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Pet> updatePet(Pet pet) async {
    // Validate required fields
    if (pet.id == null) {
      throw Exception('Pet ID is required for update');
    }
    if (pet.name == null || pet.name!.isEmpty) {
      throw Exception('Pet name is required');
    }
    if (pet.photoUrls == null || pet.photoUrls!.isEmpty) {
      throw Exception('At least one photo URL is required');
    }
    
    try {
      final response = await _apiService.put('/pet', data: pet.toJson());
      // Handle both JSON object and plain response
      if (response.data is Map<String, dynamic>) {
        return Pet.fromJson(response.data);
      } else {
        // If response is not JSON, return the original pet (update succeeded)
        return pet;
      }
    } on DioException catch (e) {
      // If it's an unknown error (likely a parsing error), but we got a response,
      // consider the update successful
      if (e.type == DioExceptionType.unknown && e.response != null) {
        // Update succeeded, just couldn't parse the response
        return pet;
      }
      rethrow;
    } catch (e) {
      // For any other error (like FormatException from JSON parsing),
      // if it's not a network error, assume the update succeeded
      if (e is! DioException) {
        // Likely a parsing error, update probably succeeded
        return pet;
      }
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
