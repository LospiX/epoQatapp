import 'dart:async';
import 'dart:io' show Directory;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  DatabaseHelper._internal();

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'impro_app.db');
    
    // Ensure the directory exists
    await Directory(dirname(path)).create(recursive: true);
    
    // Open the database with appropriate options for each platform
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Clear existing data
      await db.execute('DELETE FROM idea_elements');
      
      // Insert new default data (old format)
      await _insertDefaultDataLegacy(db);
    }
    if (oldVersion < 4) {
      // Create categories table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS idea_categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          display_name TEXT NOT NULL,
          color INTEGER NOT NULL,
          icon INTEGER NOT NULL,
          sort_order INTEGER NOT NULL DEFAULT 0,
          is_default INTEGER NOT NULL DEFAULT 0
        )
      ''');

      // Insert default categories
      final defaultCategories = _defaultCategories();
      final categoryIdMap = <String, int>{};
      for (final cat in defaultCategories) {
        final catId = await db.insert('idea_categories', cat);
        categoryIdMap[cat['name'] as String] = catId;
      }

      // Add category_id column to idea_elements
      await db.execute(
        'ALTER TABLE idea_elements ADD COLUMN category_id INTEGER REFERENCES idea_categories(id)',
      );

      // Populate category_id from existing type column
      for (final entry in categoryIdMap.entries) {
        await db.execute(
          'UPDATE idea_elements SET category_id = ? WHERE type = ?',
          [entry.value, entry.key],
        );
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create categories table
    await db.execute('''
      CREATE TABLE idea_categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        display_name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon INTEGER NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create elements table with category_id FK
    await db.execute('''
      CREATE TABLE idea_elements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        value TEXT NOT NULL,
        category_id INTEGER REFERENCES idea_categories(id)
      )
    ''');
    
    // Insert default data
    await _insertDefaultData(db);
  }

  // Default categories definition
  List<Map<String, dynamic>> _defaultCategories() => [
    {
      'name': 'character',
      'display_name': 'Personaggio',
      'color': Colors.blue.value,
      'icon': Icons.person.codePoint,
      'sort_order': 0,
      'is_default': 1,
    },
    {
      'name': 'trait',
      'display_name': 'Carattere',
      'color': Colors.purple.value,
      'icon': Icons.psychology.codePoint,
      'sort_order': 1,
      'is_default': 1,
    },
    {
      'name': 'object',
      'display_name': 'Oggetto',
      'color': Colors.orange.value,
      'icon': Icons.category.codePoint,
      'sort_order': 2,
      'is_default': 1,
    },
    {
      'name': 'location',
      'display_name': 'Luogo',
      'color': Colors.green.value,
      'icon': Icons.location_on.codePoint,
      'sort_order': 3,
      'is_default': 1,
    },
    {
      'name': 'emotion',
      'display_name': 'Emozione',
      'color': Colors.red.value,
      'icon': Icons.emoji_emotions.codePoint,
      'sort_order': 4,
      'is_default': 1,
    },
  ];

  // Default items grouped by category name
  Map<String, List<String>> _defaultItems() => {
    'character': [
      'Astronauta in pensione',
      'Chef stellato',
      'Street artist misterioso',
      'Hacker etico con passato oscuro',
      'Tatuatrice di codici quantici',
      'Neurochirurgo con memoria eidética',
      'Ex agente dei servizi segreti',
      'Collezionista di tempi perduti',
      'Ingegnere di realtà alternative',
      'Linguista di lingue estinte',
      'Cartografo di dimensioni parallele',
      'Bambina che parla con i numeri',
      'Ex bambino prodigio dello spionaggio',
      "Falsario di opere d'arte metafisiche",
      'Guardiano della biblioteca proibita',
      'Pilota di drone da guerra pentito',
      'Alchimista digitale',
      'Ribelle del deep web',
      'Medium tecnologico',
      'Architetto di città invisibili',
    ],
    'trait': [
      'Sarcastico',
      'Genio distratto',
      'Cinico romantico',
      'Empatico borderline',
      'Perfezionista autodistruttivo',
      'Scettico illuminato',
      'Visionario pragmatico',
      'Opportunista con principi',
      'Ribelle metodico',
      'Ottimista catastrofista',
      'Cinico sentimentale',
      'Logico caotico',
      'Introverso performativo',
      'Estroverso claustrofobico',
      'Pessimista entusiasta',
      'Realista magico',
      'Anarchico organizzato',
      'Romantico cinico',
      'Sognatore concreto',
      'Cynic with a hidden heart of gold',
    ],
    'object': [
      'Orologio antico',
      'Borsa piena di diamanti',
      'Violino Stradivari',
      'Mappa tatuata su pelle',
      'Dischetto con IA incompleta',
      'Anello con microfilm nascosto',
      'Taccuino di equazioni quantistiche',
      'Scatola musicale meccanica',
      'Fiala di virus rigenerativo',
      'Specchio che mostra verità scomode',
      'Guanto che scrive pensieri',
      'Bussola che punta ai rimpianti',
      'Cappello che assorbe ricordi',
      'Ombrello che crea microclimi',
      'Occhiali che vedono probabilità',
      "Libro con pagine bianche che si riempiono d'inchiostro emotivo",
      'Radiolina che capta conversazioni dal passato',
      'Penna che scrive con inchiostro di stelle',
      'Bottiglia contenente un universo in miniatura',
      'Maschera che mostra il vero volto delle persone',
    ],
    'location': [
      'Mercato delle pulci di Parigi',
      'Caffè letterario di Venezia',
      'Tempio nascosto nel Himalaya',
      'Città sommersa nel Adriatico',
      'Archivio proibito Vaticano',
      'Laboratorio segreto Tesla',
      'Osservatorio abbandonato in Patagonia',
      'Metropolitana fantasma Londra',
      'Giungla urbana Kowloon',
      'Stazione spaziale abbandonata in orbita geostazionaria',
      'Cimitero di navi nel deserto del Sahara',
      'Foresta di cristalli sonanti in Brasile',
      'Città galleggiante sopra le nuvole del Pacifico',
      'Labirinto di specchi nel sottosuolo di Tokyo',
      'Isola vulcanica con biblioteca ancestrale',
      'Cattedrale sommersa nel Mar Baltico',
      'Miniera di dati abbandonata nella Silicon Valley',
      'Oasi artificiale nel deserto digitale',
      'Stazione meteorologica abbandonata in Antartide',
      'Torre di comunicazione infestata dai ricordi',
      'Sottomarino',
      'Cimitero',
      'Bunker antiatomico',
      "Casa sull'albero",
      'Libreria',
      'Negozio di usato',
      'Ermitage',
      'Cantina vinicola',
      'Ferramenta',
      'Self service',
      'Eremo',
      'Teatro',
      'Metropolitana',
      'Labirinto',
      'Serra',
      'Campanile',
      'Bar del porto',
      'Dungeon',
      'Piscina',
      'Diligenza',
      'Marte',
      'Il Circo',
      'Bivacco',
      'Negozio di animali',
      'Moletta',
      'Restauratore',
      'Gradinata stadio',
      'Onoranze funebri',
      'Vivaio',
      'Chiatta sul fiume',
      'Tribunale',
      'Villaggio tribale',
      'Agenzia delle entrate',
      'Sauna',
      'Conservatorio',
      'Negozio di lampadari',
      'Vulcano',
      'Dungeon medievale',
      'Medico alternativo',
      'Fattoria',
      'Capanna pellerossa',
      'Negozio di materiale informatico',
      "Galleria d'arte",
      'Tipografia',
      'Piattaforma petrolifera',
      'Concorso di poesia',
      'Prove teatrali',
      'Esperto feng shui',
      'Oreficeria',
      'Riunione insegnanti',
      'Redazione giornalistica',
      'Studio grafico',
      'Logopedista',
      'Rider',
      'Studio tatuaggi',
      'Benzinaio',
      'Estetista',
      'Call center',
      'Portineria notturna',
      'Riunione disagi sociali',
      'Corso per venditore',
      'Consiglio di amministrazione di...',
      'Campionato mondiale di taglialegna',
      'Polo nord',
      'Stazione spaziale',
      'Suk',
      'Concorso pubblico',
      'Jazz club',
      'Bar di paese',
      'Convegno di micologia',
      'Sfilata di moda',
      'Negozio biologico',
      'Negozio di vinili',
      'Cantiere edile',
      'Circolo di lettura',
      'Bisca clandestina',
      'Casinò',
      'Fonderia',
      'Convegno rappresentanti',
      'Cartoleria',
      'Orologiaio',
      'Kebabbaro',
      'Assedio di Sarajevo',
      'Parcheggio supermercato notte',
      'Isola ecologica',
      "Bivacco d'alta quota",
      'Studio Psicologo',
      'Negozio filatelia',
      'Sala operatoria',
      'Negozio bio',
      'Fiera del libro',
      'Corso di...',
      'Sagra del boscaiolo',
      'Gara di spiedo bresciano',
      'Fronte austriaco 1^ guerra M.',
      'Abazia belga',
      "Atelier d'arte",
      'Incubatoio informatico',
      'Autolavaggio',
      'Sala cinematografica',
      'Sala prove band',
      'Edicola',
      'Consorzio Agrario',
      'Drive in',
      'Rifugio Alpino',
      'Scuola di clown',
      'Seminario',
      'Dentro a un PC',
      'Tepee',
      'Giovurio',
      'Teletubbieslandia',
      'Nautilus',
      'Set cinematografico',
      'Fabbrica di matite',
      'Ikea',
      'Corso di sport estremi',
      'Macello',
      'Dog sitting hotel',
      'Baby sitting house',
      'La casa di Babbo Natale',
      'Sartoria',
      'Laboratorio di ricerca',
      'Ministero degli umarel',
      'Club di modellismo',
      'Sexy shop',
      'Setta segreta',
      'Viaggio organizzato',
      'Officina meccanica',
      'Silicon Valley',
      'Industria chimica',
      'Carcere',
      'Scavo archeologico',
      'Davanti a un caminetto',
      'Su un pontile',
      "Sulla cima dell'Everest",
      'Festa della donna',
      'Mercato degli schiavi',
      'Dal meccanico',
      'Consiglio di quartiere',
      'Risaia',
      'Notaio',
      'Fumetteria',
      'Dopolavoro ferroviario',
      'Circolo Pensionati Comunisti',
      'Ufficio Oggetti Smarriti',
      'Corniciaio',
      'Giunta Comunale',
      'Sotto una notte stellata',
      'Milonga',
      'Sala da biliardo',
    ],
    'emotion': [
      'Gioia', 'Tristezza', 'Rabbia', 'Paura', 'Sorpresa',
      'Disgusto', 'Anticipazione', 'Fiducia', 'Aspettativa', 'Ottimismo',
      'Amare', 'Apprensione', 'Estasi', 'Adorazione', 'Terrore',
      'Vigilanza', 'Rimorso', 'Contrizione', 'Sdegno', 'Invidia',
      'Imbarazzo', 'Nostalgia', 'Euforia', 'Serenità', 'Desiderio',
      'Confusione', 'Soddisfazione', 'Disprezzo', 'Orgoglio', 'Vergogna',
      'Speranza', 'Gratitudine', 'Tenerezza', 'Isolazione', 'Empatia',
      'Entusiasmo', 'Rassegnazione', 'Indifferenza', 'Curiosità', 'Stupore',
    ],
  };

  // Fresh install: insert default categories then default items with category_id
  Future<void> _insertDefaultData(Database db) async {
    final categories = _defaultCategories();
    final items = _defaultItems();
    final categoryIdMap = <String, int>{};

    for (final cat in categories) {
      final catId = await db.insert('idea_categories', cat);
      categoryIdMap[cat['name'] as String] = catId;
    }

    for (final entry in items.entries) {
      final categoryId = categoryIdMap[entry.key]!;
      for (final value in entry.value) {
        await db.insert('idea_elements', {
          'type': entry.key,
          'value': value,
          'category_id': categoryId,
        });
      }
    }
  }

  // Legacy insert for migration from v2→v3 (no category_id)
  Future<void> _insertDefaultDataLegacy(Database db) async {
    final items = _defaultItems();
    for (final entry in items.entries) {
      for (final value in entry.value) {
        await db.insert('idea_elements', {
          'type': entry.key,
          'value': value,
        });
      }
    }
  }

  // ─── Category CRUD ───

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('idea_categories', orderBy: 'sort_order ASC');
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await database;
    final results = await db.query(
      'idea_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isEmpty ? null : results.first;
  }

  Future<int> addCategory({
    required String name,
    required String displayName,
    required int color,
    required int icon,
  }) async {
    final db = await database;
    final maxOrder = Sqflite.firstIntValue(
      await db.rawQuery('SELECT MAX(sort_order) FROM idea_categories'),
    ) ?? -1;
    return await db.insert('idea_categories', {
      'name': name,
      'display_name': displayName,
      'color': color,
      'icon': icon,
      'sort_order': maxOrder + 1,
      'is_default': 0,
    });
  }

  Future<int> updateCategory({
    required int id,
    required String displayName,
    required int color,
    required int icon,
  }) async {
    final db = await database;
    return await db.update(
      'idea_categories',
      {
        'display_name': displayName,
        'color': color,
        'icon': icon,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategoryWithElements(int categoryId) async {
    final db = await database;
    await db.delete('idea_elements', where: 'category_id = ?', whereArgs: [categoryId]);
    await db.delete('idea_categories', where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<void> reorderCategories(List<int> orderedCategoryIds) async {
    final db = await database;
    final batch = db.batch();
    for (int i = 0; i < orderedCategoryIds.length; i++) {
      batch.update(
        'idea_categories',
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [orderedCategoryIds[i]],
      );
    }
    await batch.commit(noResult: true);
  }

  // ─── Element CRUD ───

  Future<List<Map<String, dynamic>>> getElementsByType(String type) async {
    final db = await database;
    return await db.query(
      'idea_elements',
      where: 'type = ?',
      whereArgs: [type],
    );
  }

  Future<List<Map<String, dynamic>>> getElementsByCategoryId(int categoryId) async {
    final db = await database;
    return await db.query(
      'idea_elements',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<int> addElement(String type, String value, {int? categoryId}) async {
    final db = await database;
    return await db.insert('idea_elements', {
      'type': type,
      'value': value,
      'category_id': categoryId,
    });
  }

  Future<int> deleteElement(int id) async {
    final db = await database;
    return await db.delete(
      'idea_elements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateElement(int id, String value) async {
    final db = await database;
    return await db.update(
      'idea_elements',
      {'value': value},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getElementCountForCategory(int categoryId) async {
    final db = await database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM idea_elements WHERE category_id = ?',
        [categoryId],
      ),
    );
    return result ?? 0;
  }

  // ─── Bulk import ───

  Future<void> importCategoryWithElements({
    required String name,
    required String displayName,
    required int color,
    required int icon,
    required List<String> items,
  }) async {
    final db = await database;
    final catId = await addCategory(
      name: name,
      displayName: displayName,
      color: color,
      icon: icon,
    );
    for (final item in items) {
      await db.insert('idea_elements', {
        'type': name,
        'value': item,
        'category_id': catId,
      });
    }
  }
}
