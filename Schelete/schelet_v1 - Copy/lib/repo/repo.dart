import 'package:schelet_v1/domain/entity.dart';
import 'package:schelet_v1/repo/local_db.dart';

class Repo {

  LocalDB db = LocalDB.instance;

  List<Entity> entities = <Entity>[];

  Future<Entity> addEntity(Entity entity) async {
    //daca n ai server, daca ai sterge asta sau pune o pe un if
    entity.id = nextId();
    Entity added = await db.create(entity);
    entities.add(added);
    return added;
  }

  void deleteEntity(int id) async {
    db.delete(id);
    entities.removeWhere((entity) => entity.id == id);
  }

  Future<List<Entity>> getAll() async {
    entities = await db.getAll();
    return entities;
  }

  int nextId() {
    int id = 0;
    entities.forEach((entity) {
      if(entity.id >= id) {
          id = entity.id + 1;
      }
    });
    return id;
  }

}

Future<Repo> getRepo() async{
  Repo repo = Repo();
  await repo.getAll();

  return repo;
}