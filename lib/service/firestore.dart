import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{

    //get
    final CollectionReference pokemon = FirebaseFirestore.instance.collection('pokemon');

    //create
    Future<void> addPokemon(String Nama,String Element,int ATK, int DEF, int HP, String Rarity){
      return pokemon.add({
        'Nama': Nama,
        'Element':Element,
        'ATK':ATK,
        'DEF': DEF,
        'HP': HP,
        'Rarity':Rarity
      });
    }


    //read
    Stream<QuerySnapshot> getPokemon(){
      final pokemonStream = pokemon.orderBy('Nama',descending: false).snapshots();
      return pokemonStream;
    }

    //update
    Future<void> updatePokemon(String ID, String Nama,String Element,int ATK, int DEF, int HP, String Rarity){
      return pokemon.doc(ID).update({
        'Nama': Nama,
        'Element':Element,
        'ATK':ATK,
        'DEF': DEF,
        'HP': HP,
        'Rarity':Rarity
      });
    }


    //delete

Future<void> deletePokemon(String ID){
      return pokemon.doc(ID).delete();
}
}