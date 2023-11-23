import 'package:dam_u3_practica2/firebase.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _index = 0;
  final nombre = TextEditingController();
  final direccion = TextEditingController();
  final capacidad = TextEditingController();
  final descripcion = TextEditingController();
  final tipoComida = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sisi Food"),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list),label: "Explorar"),
            BottomNavigationBarItem(icon: Icon(Icons.add),label: "Nuevo"),
          ],
          currentIndex: _index,
          onTap: (valor){
          setState(() {
          _index = valor;
          });
          }
      ),
    );
  }

  Widget dinamico(){
    switch(_index){
      case 0:{
        return FutureBuilder(
            future: FireS.mostrarTodo(),
            builder: (context,lista){
              return ListView.builder(
                  itemCount: lista.data?.length,
                  itemBuilder: (context,i){
                    return Column(
                      children: [
                        ListTile(
                          title: Text('${lista.data?[i]['nombre'] ?? 'No hay restaurantes disponibles'}', style: TextStyle(fontSize: 18),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lista.data?[i]['tipoComida']} | ${lista.data?[i]['direccion']} | ${lista.data?[i]['capacidad']} personas',
                              ),
                              SizedBox(height: 5,),
                              Text(
                                '${lista.data?[i]['descripcion'] ?? ''}',
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Expanded(
                                  child: IconButton(
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Eliminar restaurante'),
                                              content: Text('¿Eliminar?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FireS.eliminar(lista.data?[i]['id']);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Eliminar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete)
                                  ),
                              ),
                              Expanded(
                                  child: IconButton(
                                      onPressed: (){
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              Map<String, dynamic> r = {
                                                'id':lista.data?[i]['id'],
                                                'nombre':lista.data?[i]['nombre'],
                                                'direccion':lista.data?[i]['direccion'],
                                                'tipoComida':lista.data?[i]['tipoComida'],
                                                'capacidad':lista.data?[i]['capacidad'],
                                                'descripcion':lista.data?[i]['descripcion'],
                                              };
                                              return Center(
                                                child: actualizar(r),
                                              );
                                            }
                                        );
                                      },
                                      icon: Icon(Icons.mode_rounded)
                                  ),
                              )
                            ],
                          )
                        )
                      ],
                    );
                  }//ib
              );
            });
      }//case0
      case 1:{
        return Center(
          child: ListView(
            padding: EdgeInsets.all(30),
            children: [
              TextField(
                controller: nombre,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
                  label: Text("Nombre del restaurante"),
                ),
              ),
              SizedBox(height: 25,),
              TextField(
                controller: direccion,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.directions),
                  label: Text("Dirección"),
                ),
              ),
              SizedBox(height: 25,),
              TextField(
                controller: tipoComida,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.restaurant),
                  label: Text("¿Qué tipo de comida ofrece?"),
                ),
              ),
              SizedBox(height: 25,),
              TextField(
                controller: capacidad,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.reduce_capacity),
                  label: Text("Capacidad de personas"),
                ),
              ),
              SizedBox(height: 25,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_fields),
                  label: Text("Descripción general"),
                ),
              ),
              SizedBox(height: 25,),
              FilledButton(
                  onPressed: (){
                    Map<String, dynamic> r = {
                      'nombre': nombre.text,
                      'direccion': direccion.text,
                      'tipoComida': tipoComida.text,
                      'capacidad':int.parse(capacidad.text),
                      'descripcion': descripcion.text
                    };
                    setState(() {
                      FireS.insertar(r);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Guardar")
              )
            ],
          ),
        );
      }//case 1
    }//sw
    return Center();
  }


  //actualizat
  Widget actualizar(Map<String, dynamic> r){
    if(nombre.text.isEmpty){
      nombre.text = r['nombre'] ?? '';
      direccion.text = r['direccion'] ?? '';
      tipoComida.text = r['tipoComida'] ?? '';
      capacidad.text = r['capacidad']?.toString() ?? '';
      descripcion.text = r['descripcion'] ?? '';
    }

    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          TextField(
            controller: nombre,
            decoration: InputDecoration(
              labelText: 'Restaurante',
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: direccion,
            decoration: InputDecoration(
              labelText: 'Dirección',
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: tipoComida,
            decoration: InputDecoration(
              labelText: 'Tipo de comida que ofrece',
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: capacidad,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Capacidad',
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: descripcion,
            decoration: InputDecoration(
              labelText: 'Descripcion breve',
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    nombre.text = direccion.text = tipoComida.text = capacidad.text = descripcion.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              SizedBox(width: 20,),
              ElevatedButton(
                  onPressed: (){
                    r['nombre'] = nombre.text;
                    r['direccion'] = direccion.text;
                    r['tipoComida'] = tipoComida.text;
                    r['capacidad'] = int.parse(capacidad.text);
                    r['descrpcion'] = descripcion.text;
                    setState(() {
                      FireS.actualizar(r);
                    });
                    nombre.text = direccion.text = tipoComida.text = capacidad.text = descripcion.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text('Guardar cambios')),
            ],
          )
        ],
      ),
    );
  }
  }

