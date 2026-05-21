import 'package:food_delivery/domain/managers/supabase_manager.dart';
import 'package:food_delivery/presentation/view_models/auth_viewmodel.dart';
import 'package:food_delivery/presentation/view_models/home_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

class DependencyInjectionContainer {
  static void init() {
    sl.registerLazySingleton<SupabaseManager>(() => SupabaseManager());
    sl.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
    sl.registerFactory<HomeViewModel>(() => HomeViewModel());
  }
}
