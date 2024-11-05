import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

//! Variablen hierhin packen damit diese nicht immer neu gebildet werden
  TextEditingController postleitzahl = TextEditingController();
//! wichtig das Fragezeichen steht für nullable
  Future<String>? getInputPlz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SafeArea(
            child: Column(
              children: [
                TextFormField(
                  //! Hier wird der Controller festgesetzt um Inhalte aus dem Textformfiled zu entnehmen
                  controller: postleitzahl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Postleitzahl"),
                ),
                const SizedBox(height: 32),
                //! Der Future Buileder darf nicht direkt in die Onpressed Funktion
                FutureBuilder(
                  future: getInputPlz,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text("Die gefundene Stadt ist:${snapshot.data}",
                          style: Theme.of(context).textTheme.labelLarge);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}",
                          style: Theme.of(context).textTheme.labelLarge);
                    }
                    return const Text("null");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: () {
                    //! Hier wird das Future getinput mit Daten gefühlt. Diese werden direkt aus dem Textfield an dei Methode übergeben und diese returned dann denn wert
                    setState(() {
                      getInputPlz = getCityFromZip(postleitzahl.text);
                    });
                  },
                  child: const Text("Suche"),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    postleitzahl.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String plz) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (plz) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}
