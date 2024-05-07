import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/service/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final FireStoreService fireStoreService = new FireStoreService();

  final TextEditingController name = TextEditingController();
  final TextEditingController element = TextEditingController();
  final TextEditingController atk = TextEditingController();
  final TextEditingController def = TextEditingController();
  final TextEditingController rarity = TextEditingController();
  final TextEditingController hp = TextEditingController();
  final ScrollController _firstController = ScrollController();


  void openPokemon(){
    showDialog(context: context,
        builder: (context)=> AlertDialog(
          title: Text('Tambah Pokemon'),
          content: SingleChildScrollView(
            controller: _firstController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Nama'),
                    controller: name,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Element'),
                    controller: element,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'HP'),
                    controller: hp,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Attack'),
                    controller: atk,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Defense'),
                    controller: def,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.only(top: 8),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Rarity'),
                    controller: rarity,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(onPressed: () {
              int Attack = int.parse(atk.text);
              int Defense = int.parse(def.text);
              int Health = int.parse(hp.text);
                fireStoreService.addPokemon(name.text, element.text, Attack, Defense, Health, rarity.text);
                clear();
                Navigator.pop(context);

            },
            child: Text('Add'),)
          ],
        ),
    );
  }

  void editPokemon(String? ID,String Nama,String Element,int ATK, int DEF, int HP, String Rarity){
    TextEditingController nameEdit = TextEditingController(text: Nama);
    TextEditingController elementEdit = TextEditingController(text: Element);
    TextEditingController atkEdit = TextEditingController(text: ATK.toString());
    TextEditingController defEdit = TextEditingController(text: DEF.toString());
    TextEditingController hpEdit = TextEditingController(text: HP.toString());
    TextEditingController rarityEdit = TextEditingController(text: Rarity);

    showDialog(context: context,
      builder: (context)=> AlertDialog(
        title: Text('Edit data $Nama'),
        content: SingleChildScrollView(
          controller: _firstController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Nama'),
                  controller: nameEdit,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Element'),
                  controller: elementEdit,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'HP'),
                  controller: hpEdit,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Attack'),
                  controller: atkEdit,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Defense'),
                  controller: defEdit,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Rarity'),
                  controller: rarityEdit,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () {
            int Attack = int.parse(atkEdit.text);
            int Defense = int.parse(defEdit.text);
            int Health = int.parse(hpEdit.text);
              fireStoreService.updatePokemon(ID!, nameEdit.text, elementEdit.text, Attack, Defense, Health, rarityEdit.text);
              Navigator.pop(context);

          },
            child: Text('Add'),)
        ],
      ),
    );
  }

  void clear(){
    name.clear();
    element.clear();
    atk.clear();
    def.clear();
    rarity.clear();
    hp.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokemon Card"),centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        openPokemon();
        },
        child: Icon(Icons.add_card_sharp),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getPokemon(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            List pokemonList = snapshot.data!.docs;

            return ListView.builder(
              itemCount:  pokemonList.length,
                itemBuilder: (context, index){
                  // mendapatkan document
                  DocumentSnapshot document = pokemonList[index];
                  String pokeID = document.id;

                  //mendapatkan semua document
                  Map<String, dynamic> data = document.data() as Map<String,dynamic>;
                  String pokeName = data['Nama'];
                  int pokeAtk = data['ATK'];
                  int pokeDef = data['DEF'];
                  int pokeHp = data['HP'];
                  String pokeRarity = data['Rarity'];
                  String pokeElement = data['Element'];

                  //tampilkan data
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.electric_bike),
                      title: Text(pokeName),
                      tileColor: Colors.cyan,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: (){
                            editPokemon(pokeID,pokeName,pokeElement,pokeAtk,pokeDef,pokeHp,pokeRarity);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(onPressed: (){
                            fireStoreService.deletePokemon(pokeID);
                          }, icon: Icon(Icons.delete))
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<Widget>(builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(title: Text('$pokeName')),
                            body: Center(
                              child: Hero(
                                tag: pokeName,
                                child: Column(
                                  children: [
                                    Icon(Icons.accessible),
                                    const SizedBox(height: 10,),
                                    Text('Nama: $pokeName'),
                                    const SizedBox(height: 10,),
                                    Text('Element: $pokeElement'),
                                    const SizedBox(height: 10,),
                                    Text('HP: $pokeHp'),
                                    const SizedBox(height: 10,),
                                    Text('Attack: $pokeAtk'),
                                    const SizedBox(height: 10,),
                                    Text('Defense: $pokeDef'),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }));
                      },
                    ),
                  );

                }
            );
          }
          else{
            return const Text("Pokemon kosong");
          }
        },
      ),
    );
  }
}
