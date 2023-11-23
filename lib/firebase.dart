import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore bd = FirebaseFirestore.instance;

class FireS {

  static Future<List> mostrarTodo() async {
    List restaurantes = [];

    var query = await bd.collection('restaurantes').get();
    query.docs.forEach((elemento) {
      Map<String, dynamic> documento = elemento.data();
      documento.addAll({'id':elemento.id});
      restaurantes.add(documento);
    });
    return restaurantes;
  }
  static Future insertar(Map<String, dynamic> p) async {
    return await bd.collection('restaurantes').add(p);
  }
  static Future eliminar(String id) async {
    return await bd.collection('restaurantes').doc(id).delete();
  }
  static Future actualizar(Map<String, dynamic> r) async {
    String id = r['id'];
    r.remove('r');
    return await bd.collection('restaurantes').doc(id).update(r);
  }

}