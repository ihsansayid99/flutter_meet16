import 'package:flutter/material.dart';
import 'package:meet_16/sql_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IhsanSayidMuharrom.com',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //All Data
  List<Map<String, dynamic>> _mahasiswa = [];

  bool _isLoading = true;

  void _refreshMahasiswa() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _mahasiswa = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMahasiswa(); // Loaddata when the app starts
  }

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tugasController = TextEditingController();
  final TextEditingController _utsController = TextEditingController();
  final TextEditingController _uasController = TextEditingController();
  final TextEditingController _nilaiAkhirController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingMahasiswa =
          _mahasiswa.firstWhere((element) => element['id'] == id);
      _nimController.text = existingMahasiswa['nim'];
      _nameController.text = existingMahasiswa['name'];
      _tugasController.text = existingMahasiswa['tugas'].toString();
      _utsController.text = existingMahasiswa['uts'].toString();
      _uasController.text = existingMahasiswa['uas'].toString();
      _nilaiAkhirController.text = existingMahasiswa['nilaiAkhir'].toString();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      builder: (_) => Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nimController,
                decoration: InputDecoration(hintText: 'NIM Anda'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'name Anda'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _tugasController,
                decoration: InputDecoration(hintText: 'tugas Anda'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _utsController,
                decoration: InputDecoration(hintText: 'uts Anda'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _uasController,
                decoration: InputDecoration(hintText: 'uas Anda'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nilaiAkhirController,
                decoration: InputDecoration(hintText: 'nilaiAkhir Anda'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }

                  //clear textbox
                  _nimController.text = '';
                  _nameController.text = '';
                  _tugasController.text = '';
                  _utsController.text = '';
                  _uasController.text = '';
                  _nilaiAkhirController.text = '';

                  //close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create new' : 'Update'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    await SQLHelper.createMahasiswa(
        _nimController.text,
        _nameController.text,
        double.parse(_tugasController.text),
        double.parse(_utsController.text),
        double.parse(_uasController.text),
        double.parse(_nilaiAkhirController.text));
    _refreshMahasiswa();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _nimController.text,
        _nameController.text,
        double.parse(_tugasController.text),
        double.parse(_utsController.text),
        double.parse(_uasController.text),
        double.parse(_nilaiAkhirController.text));
    _refreshMahasiswa();
  }

  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Successfully deleted mahasiswa!"),
    ));
    _refreshMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ismuhr.eth"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _mahasiswa.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_mahasiswa[index]['name']),
                  subtitle: Text(_mahasiswa[index]['nim']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _showForm(_mahasiswa[index]['id']),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteItem(_mahasiswa[index]['id']),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
