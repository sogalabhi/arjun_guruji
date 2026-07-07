import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:hive/hive.dart';

abstract class AstottarasLocalDataSource {
  List<AstottaraModel> getCachedAstottaras();
  Future<void> cacheAstottaras(List<AstottaraModel> list);
  Future<void> clearCache();
}

class AstottarasLocalDataSourceImpl implements AstottarasLocalDataSource {
  final Box<AstottaraModel> astottaraBox;

  AstottarasLocalDataSourceImpl({required this.astottaraBox});

  @override
  List<AstottaraModel> getCachedAstottaras() {
    return astottaraBox.values.toList();
  }

  @override
  Future<void> cacheAstottaras(List<AstottaraModel> list) async {
    await astottaraBox.clear();
    for (final astottara in list) {
      await astottaraBox.put(astottara.title, astottara);
    }
  }

  @override
  Future<void> clearCache() async {
    await astottaraBox.clear();
  }
}
