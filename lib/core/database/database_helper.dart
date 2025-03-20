import 'dart:async';
import 'dart:io' show Directory;
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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Clear existing data
      await db.execute('DELETE FROM idea_elements');
      
      // Insert new default data
      await _insertDefaultData(db);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE idea_elements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
    
    // Insert default data
    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    // Character data
    final characters = [
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
    ];
    
    // Trait data
    final traits = [
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
    ];
    
    // Object data
    final objects = [
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
    ];
    
    // Location data
    final locations = [
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
'Cimitero ',
'Bunker antiatomico',
'Casa sull\'albero ',
'Libreria ',
'Negozio di usato',
'Ermitage ',
'Cantina vinicola ',
'Ferramenta ',
'Self service',
'Eremo',
'Teatro ',
'Metropolitana ',
'Labirinto ',
'Serra',
'Campanile ',
'Bar del porto',
'Dungeon ',
'Piscina ',
'Diligenza ',
'Marte',
'Il Circo',
'Bivacco',
'Negozio di animali ',
'Moletta',
'Restauratore',
'Gradinata stadio',
'Onoranze funebri ',
'Vivaio',
'Chiatta sul fiume',
'Tribunale ',
'Villaggio tribale',
'Agenzia delle entrate ',
'Sauna',
'Conservatorio ',
'Negozio di lampadari ',
'Vulcano',
'Dungeon medievale',
'Medico alternarivo',
'Fattoria',
'Capanna pellerossa ',
'Negozio di materiale informatico ',
'Galleria d\'arte ',
'Tipografia ',
'Piattaforma petrolifera ',
'Concorso di poesia ',
'Prove teatrali ',
'Esperto feng shui',
'Oreficeria ',
'Riunione insegnanti ',
'Redazione giornalistica ',
'Studio grafico ',
'Logopedista ',
'Rider',
'Studio tatuaggi',
'Benzinaio ',
'Estetista ',
'Call center',
'Portineria notturna ',
'Riunione disagi sociali',
'Corso per venditore',
'Consiglio di amministrazione di...',
'Campionato mondiale di taglialegna ',
'Polo nord',
'stazione spaziale ',
'Suk',
'Concorso pubblico',
'Jazz club',
'Bar di paese',
'Convegno di micologia ',
'Sfilata di moda',
'Negozio biologico ',
'Negozio di vinili',
'Cantiere edile ',
'Negozio di lampadari',
'Circolo di lettura ',
'Bisca clandestina',
'Casinò',
'Fonderia',
'Convegno rappresentanti',
'Cartoleria ',
'Orologiaio',
'Kebabbaro',
'Assedio di Sarajevo',
'Parcheggio supermercato notte ',
'Isola ecologica ',
'Bivacco d\'alta quota',
'Studio Psicologo ',
'Negozio filatelia ',
'Sala operatoria',
'Negozio bio',
'Cimitero',
'Fiera del libro ',
'Corso di...',
'Sagra del boscaiolo ',
'Gara di spiedo bresciano ',
'Fronte austriaco 1^ guerra M.',
'Abazia belga',
'Atelier d\'arte ',
'Incubatoio informatico',
'autolavaggio',
'Sala cinematografica',
'Sala prove band',
'edicola ',
'estetista ',
'Consorzio Agrario ',
'Drive in',
'Rifugio Alpino',
'Scuola di clown',
'Seminario ',
'Dentro a un PC',
'Tepee ',
'Cantiere edile ',
'Giovurio',
'Teletubbieslandia',
'Nautilus ',
'Set cinematografico ',
'Fabbrica di matite',
'Ikea',
'Corso di sport estremi ',
'Macello',
'Dog sitting hotel ',
'Baby sitting house',
'La casa di Babbo Natale ',
'Sartoria ',
'laboratorio di ricerca ',
'Ministero degli umarel',
'Club di modellismo ',
'Sexy shop ',
'Setta segreta',
'Consorzio agrario ',
'Viaggio organizzato ',
'Officina meccanica ',
'Silicon Valley',
'Industria chimica ',
'Piattaforma petrolifera',
'Carcere',
'Scavo archeologico ',
'davanti a un caminetto ',
'su un pontile ',
'sulla cima dell\'Everest ',
'festa della donna ',
'mercato degli schiavi ',
'dal meccanico ',
'consiglio di quartiere ',
'Risaia',
'Notaio',
'Fumetteria ',
'Dopolavoro ferroviario',
'Circolo Pensionati Comunisti ',
'Ufficio Oggetti Smarriti ',
'Corniciaio',
'Estetista ',
'Giunta Comunale ',
'Sotto una notte stellata ',
'Milonga',
'Sala da biliardo ',
'Tribunale',
    ];
    
    // Emotion data
    final emotions = [
      'Gioia', 'Tristezza', 'Rabbia', 'Paura', 'Sorpresa', 
      'Disgusto', 'Anticipazione', 'Fiducia', 'Aspettativa', 'Ottimismo', 
      'Amare', 'Apprensione', 'Estasi', 'Adorazione', 'Terrore', 
      'Vigilanza', 'Rimorso', 'Contrizione', 'Sdegno', 'Invidia', 
      'Imbarazzo', 'Nostalgia', 'Euforia', 'Serenità', 'Desiderio', 
      'Confusione', 'Soddisfazione', 'Disprezzo', 'Orgoglio', 'Vergogna', 
      'Speranza', 'Gratitudine', 'Tenerezza', 'Isolazione', 'Empatia', 
      'Entusiasmo', 'Rassegnazione', 'Indifferenza', 'Curiosità', 'Stupore'
    ];
    
    // Insert character data
    for (final character in characters) {
      await db.insert('idea_elements', {
        'type': 'character',
        'value': character,
      });
    }
    
    // Insert trait data
    for (final trait in traits) {
      await db.insert('idea_elements', {
        'type': 'trait',
        'value': trait,
      });
    }
    
    // Insert object data
    for (final object in objects) {
      await db.insert('idea_elements', {
        'type': 'object',
        'value': object,
      });
    }
    
    // Insert location data
    for (final location in locations) {
      await db.insert('idea_elements', {
        'type': 'location',
        'value': location,
      });
    }
    
    // Insert emotion data
    for (final emotion in emotions) {
      await db.insert('idea_elements', {
        'type': 'emotion',
        'value': emotion,
      });
    }
  }

  // CRUD operations for idea elements
  
  // Get all elements of a specific type
  Future<List<Map<String, dynamic>>> getElementsByType(String type) async {
    final db = await database;
    return await db.query(
      'idea_elements',
      where: 'type = ?',
      whereArgs: [type],
    );
  }
  
  // Add a new element
  Future<int> addElement(String type, String value) async {
    final db = await database;
    return await db.insert('idea_elements', {
      'type': type,
      'value': value,
    });
  }
  
  // Delete an element
  Future<int> deleteElement(int id) async {
    final db = await database;
    return await db.delete(
      'idea_elements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Update an element
  Future<int> updateElement(int id, String value) async {
    final db = await database;
    return await db.update(
      'idea_elements',
      {'value': value},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
