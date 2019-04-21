import '../../base/api-service.dart';

class UserService {
  final apiService = ApiService();

  insert(String url, Map body) async {
    return await apiService.post(url, body);
  }

  edit(String url, Map body) async {
    return await apiService.put(url, body);
  }

  get(String url, Map query) async {
    return await apiService.get(url, query);
  }

  list(String url, Map query) async {
    return await apiService.get(url, query);
  }

  delete(String url, Map body) async {
    return await apiService.delete(url, body);
  }
}