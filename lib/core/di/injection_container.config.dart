import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// need to run 'dart run build_runner build' 

extension GetItInjectableX on GetIt {
  Future<GetIt> init({
    String? environment,
    EnvironmentFilter? environmentFilter,
  }) async {
    
    return this;
  }
}
