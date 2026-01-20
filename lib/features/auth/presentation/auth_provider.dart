import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../../core/network/network_client.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(NetworkClient());
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthState {
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({this.token, this.isLoading = false, this.error});

  bool get isAuthenticated => token != null;

  AuthState copyWith({String? token, bool? isLoading, String? error}) {
    return AuthState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _repository.getToken();
    state = state.copyWith(token: token);
  }

  Future<void> loginOrSignup(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _repository.signup(email, password);
      state = state.copyWith(token: token, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.clearToken();
    state = AuthState();
  }
}
