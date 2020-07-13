//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    func substring(from: Int) -> Character  {
        return self[index(startIndex, offsetBy: from)]
    }
    
    func substring(to: Int) -> String {
        return self[0 ..< to]
    }
    
    func substring(with r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        let range = start..<end
        return String(self[range])
        //return String(self[Range(start ..< end)])
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: bounds.upperBound - bounds.lowerBound)
        return String(self[startIndex..<endIndex])
    }
}

import UIKit


struct LivroCapituloVersiculo {
    var livro : String!
    var capítulo : String!
    var texto : String!
    var verse : String!
    var livroID : String!
}

struct VersosMarcados {
    var livroNome: String!
    var livroID : String!
    var capítulo : String!
    var texto : String!
    var verse : String!
    var titulo: String!
}

class DBManager: NSObject {
    
    let field_Name = "name"
    let field_NameLivro = "NomeLivro"
    let field_Testamento = "testamento"
    let field_livroID = "book_id"
    let field_capitulo = "chapter"
    let field_verse = "verse"
    let field_text = "text"
    
    let field_data_versiculo_diario = "datadia"
    let field_livro_diario = "livro"
    let field_livro_marcacao = "livroID"
    let field_capitulo_diario = "capitulo"
    let field_versiculo_diario = "versiculo"
    let field_titulo_marcacao = "titulomarcacao"
    
    let field_Fonte = "fontenormal"
    let field_Tamanho = "tamanho"
    let field_fundo_noturno = "fundo_noturno"
    
    
    //Sql para selecionar todos os versículos pelo termo escolhido - Esta já está pronto
    var sqlQuery : String = ""
    var sqlQueryCapitulo : String = ""
    var sqlQueryVerso : String = ""
    
    static let shared: DBManager = DBManager()

    let databaseFileName = "BIBLIA_NVT_AJUSTADO"
    let databaseType = "sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    var dbCaminhoReadWrite: String!

    
    override init() {
        super.init()

        if let pathToMoviesFile = Bundle.main.path(forResource: databaseFileName,
                                                   ofType: databaseType) {
            print(pathToMoviesFile)
            
            //pathToDatabase = pathToMoviesFile
            pathToDatabase = dbCaminhoReadWrite
        }
        
    }
    
    //Obtém a pasta onde ficará o banco
    func getPath(fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    //Copia o banco para a pasta de Documentos para ficar Read/write
    func copyFile(fileName: NSString) {
        let dbPath: String! = getPath(fileName: fileName as String)
        dbCaminhoReadWrite = dbPath
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL?.appendingPathComponent(fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath!.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }

            if (error != nil) {
                print( "Error Occured")
                print( error?.localizedDescription as Any)
            } else {
                print("Successfully Copy")
                print("Your database copy successfully")
            }
        }
    }
    
    
    func createDatabase() -> Bool {
        let created = false
        
        let dbCaminhoReadWrite: String = getPath(fileName: "BIBLIA_NVT_AJUSTADO.sqlite")
        pathToDatabase = dbCaminhoReadWrite
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {

            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            let dbCaminhoReadWrite: String = getPath(fileName: "BIBLIA_NVT_AJUSTADO.sqlite")
            pathToDatabase = dbCaminhoReadWrite
            
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    //Carregar os versículos passando o filtro desejado
    func loadVersiculo(complSql:String!) -> [VersoInfo]! {
        var versos: [VersoInfo]!
        
        var texto: String!
        var Procurar: String!
        
        let StringAchar: [String] = complSql.components(separatedBy: "%")
        if StringAchar.count > 0 {
            Procurar  = StringAchar[1]
        } else {
            Procurar  = StringAchar[0]
        }
    
        let ProcurarDigitado:String! = Procurar
        
        sqlQuery    = "SELECT " +
                "BO.BOOK_NAME NAME," +
                "CASE " +
                "when BO.TESTAMENT = 'AT' then \'Antigo Testamento\' " +
                "when BO.TESTAMENT = 'NT' then \'Novo Testamento\'" +
                "END AS TESTAMENTO," +
                "BI.BOOK_ID,BI.CHAPTER , BI.VERSE," +
                "BI.TEXT " +
                "FROM BIBLIA BI, BOOKS BO " +
                "WHERE BI.BOOK_ID = BO.BOOK_ID "

        if openDatabase() {
            do {
                sqlQuery += complSql
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let verso = VersoInfo(name: results.string(forColumn: field_Name),
                                          testamento: results.string(forColumn: field_Testamento),
                                          livroID: results.string(forColumn: field_livroID),
                                          capitulo: results.string(forColumn: field_capitulo),
                                          verso: results.string(forColumn: field_verse),
                                          text:results.string(forColumn: field_text))
                    
                    if versos == nil {
                        versos = [VersoInfo]()
                    }
                    
                    texto = verso.text
                    
                    var achouTexto: Bool! = false

                    //1 - procura texto com todas palavras com o texto original digitado
                    if texto.range(of: " "+ProcurarDigitado+" ") != nil {
                        achouTexto = true
                    }
                    
                    //2 - procura com a primeira letra capitalizada
                    let a:String! = ProcurarDigitado.capitalized
                    if (texto.range(of: " " + a + " ")) != nil {
                        achouTexto = true
                    }
                    
                    //3 - procura com a o texto mais vírgula
                    if texto.range(of: " " + ProcurarDigitado + ",") != nil {
                        achouTexto = true
                    }
                    
                    //4 - procura com a o texto mais ponto e vírgula
                    if texto.range(of: " " + ProcurarDigitado + ";") != nil {
                        achouTexto = true
                    }
                    
                    Procurar=Procurar.lowercased()
                    //5 - Se nao achar em maiúsculo procurar em minúsculo
                    if  texto.range(of: " "+Procurar+" ") != nil {
                        achouTexto = true
                    }
                    
                    
                    if achouTexto == true {
                        versos.append(verso)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return versos
    }
    
    //Carregar os versículos passando o filtro desejado - Detalhe do versiculo selecionado na lista
    func loadVersiculoDetalhado(complSql:String!) -> [VersoInfo]! {
        var versos: [VersoInfo]!
        
        
        sqlQuery    = "SELECT " +
            "BO.BOOK_NAME NAME," +
            "CASE " +
            "when BO.TESTAMENT = 'AT' then \'Antigo Testamento\' " +
            "when BO.TESTAMENT = 'NT' then \'Novo Testamento\'" +
            "END AS TESTAMENTO," +
            "BI.BOOK_ID,BI.CHAPTER , BI.VERSE," +
            "BI.TEXT " +
            "FROM BIBLIA BI, BOOKS BO " +
        "WHERE BI.BOOK_ID = BO.BOOK_ID "
        
        if openDatabase() {
            do {
                sqlQuery += complSql
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let verso = VersoInfo(name: results.string(forColumn: field_Name),
                                          testamento: results.string(forColumn: field_Testamento),
                                          livroID: results.string(forColumn: field_livroID),
                                          capitulo: results.string(forColumn: field_capitulo),
                                          verso: results.string(forColumn: field_verse),
                                          text:results.string(forColumn: field_text))
                    
                    if versos == nil {
                        versos = [VersoInfo]()
                    }
                    

                    versos.append(verso)

                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return versos
    }

    
    //Carregar numeros dos versiculos por Livro e Capitulo
    func loadVersiculoPorLivroCapitulo(livro:String!, capitulo: String) -> [VersoInfo]! {
        var versos: [VersoInfo]!
        
        sqlQuery    = "SELECT " +
            "BO.BOOK_NAME NAME," +
            "CASE " +
            "when BO.TESTAMENT = 'AT' then \'Antigo Testamento\' " +
            "when BO.TESTAMENT = 'NT' then \'Novo Testamento\' " +
            "END AS TESTAMENTO," +
            "BI.BOOK_ID,BI.CHAPTER , BI.VERSE," +
            "BI.TEXT " +
            "FROM BIBLIA BI, BOOKS BO " +
            "WHERE BI.BOOK_ID = BO.BOOK_ID " +
            "AND BI.BOOK_ID =  " + livro + " " +
            "AND BI.CHAPTER = " + capitulo
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let verso = VersoInfo(name: results.string(forColumn: field_Name),
                                          testamento: results.string(forColumn: field_Testamento),
                                          livroID: results.string(forColumn: field_livroID),
                                          capitulo: results.string(forColumn: field_capitulo),
                                          verso: results.string(forColumn: field_verse),
                                          text:results.string(forColumn: field_text))
                    
                    if versos == nil {
                        versos = [VersoInfo]()
                    }
                    
                    versos.append(verso)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return versos
    }

    //Carregar numeros dos versiculos por Livro e Capitulo
    func loadVersiculoPorLivroCapituloVerso(livro:String!, capitulo: String,
                                            verso:Int32) -> [VersoInfo1]! {
        var versos1: [VersoInfo1]!
        
        sqlQuery    = "SELECT BI.BOOK_ID,B.BOOK_NAME AS NAME,B.TESTAMENT AS TESTAMENTO," +
            "BI.CHAPTER, " +
            "BI.VERSE, " +
            "BI.TEXT " +
            "FROM BIBLIA BI,BOOKS B " +
            "WHERE BI.BOOK_ID = B.BOOK_ID " +
            "AND BI.BOOK_ID =  " + livro + " " +
            "AND BI.CHAPTER = " + capitulo //+ " " +
            //"AND BI.VERSE >= " + verso
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let verso = VersoInfo1(name: results.string(forColumn: field_Name),
                                          testamento: results.string(forColumn: field_Testamento),
                                          livroID: results.string(forColumn: field_livroID),
                                          capitulo: results.string(forColumn: field_capitulo),
                                          verso: results.int(forColumn: field_verse),
                                          text:results.string(forColumn: field_text))
                    
                    if versos1 == nil {
                        versos1 = [VersoInfo1]()
                    }
                    
                    versos1.append(verso)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return versos1
    }
    
    func loadLivros(complSql:String!) -> [LivrosInfo]! {
        var livros: [LivrosInfo]!
        sqlQuery = "SELECT BOOK_ID,BOOK_NAME as name FROM BOOKS "
        
        if openDatabase() {
            do {
                sqlQuery += complSql
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let livro = LivrosInfo(livroID: results.string(forColumn: field_livroID),
                                           name: results.string(forColumn: field_Name))
                    
                    if livros == nil {
                        livros = [LivrosInfo]()
                    }
                    
                    livros.append(livro)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return livros
    }

    //Carregar capítulos
    func loadCapitulos(complSql:String!) -> [CapitulosInfo]! {
        sqlQueryCapitulo = "SELECT BO.BOOK_ID AS book_id, BO.BOOK_NAME,BI.CHAPTER as chapter " +
        "FROM BIBLIA BI, BOOKS BO " +
        "WHERE " +
        "BI.BOOK_ID = BO.BOOK_ID " +
        "AND BI.BOOK_ID = " + complSql + " " +
        "GROUP BY BI.BOOK_ID, BI.CHAPTER;"
        
        var capitulos: [CapitulosInfo]!
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQueryCapitulo, values: nil)
                
                while results.next() {
                    
                    let capitulo = CapitulosInfo(Numero: results.string(forColumn: field_capitulo),
                                                 LivroID: results.string(forColumn: field_livroID))
    
                    if capitulos == nil {
                        capitulos = [CapitulosInfo]()
                    }
                    
                    capitulos.append(capitulo)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return capitulos
    }
    
    //Carregar versículo do dia - Virá aleatoriamente ou segundo uma relação fornecida pela Mundo Cristão
    func loadVersiculoDodia(livro: String, capitulo: String, versiculo: String)  -> [VersoInfo]! {
        var versos: [VersoInfo]!
        
        sqlQuery    = "SELECT BO.BOOK_ID AS book_id, BO.BOOK_NAME as name," +
        "BI.CHAPTER as chapter ,BI.TEXT,BI.VERSE as verse, " +
        "BO.TESTAMENT as TESTAMENTO " +
        "FROM BIBLIA BI, BOOKS BO " +
        "WHERE " +
        "BI.BOOK_ID = BO.BOOK_ID " +
        "AND BO.BOOK_NAME='" + livro + "' " +
        "AND BI.CHAPTER='" + capitulo + "' " +
        "AND BI.VERSE = '" + versiculo + "' " +
        "; "
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let verso = VersoInfo(name: results.string(forColumn: field_Name),
                                          testamento: results.string(forColumn: field_Testamento),
                                          livroID: results.string(forColumn: field_livroID),
                                          capitulo: results.string(forColumn: field_capitulo),
                                          verso: results.string(forColumn: field_verse),
                                          text:results.string(forColumn: field_text))
                    
                    if versos == nil {
                        versos = [VersoInfo]()
                    }
                    
                    versos.append(verso)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return versos
    }
    
    // Verificar se existe o versículo do dia
    func Verificar_versiculo_dia(dataDia: String) -> [VersiculoDoDia] {
        var versosDia: [VersiculoDoDia]!
        
        let datadia : String = String(dataDia)
        let plica : String = "'"
        sqlQuery = "SELECT DATADIA,LIVRO,CAPITULO,VERSICULO FROM VERSICULOSDIA WHERE DATADIA=\(plica)\(datadia)\(plica)"

        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                while results.next() {

                    let verso = VersiculoDoDia(datadia: results.date(forColumn: field_data_versiculo_diario),
                                               livro: results.string(forColumn: field_livro_diario),
                                               capitulo: results.string(forColumn:  field_capitulo_diario),
                                               versiculo: results.string(forColumn: field_versiculo_diario))


                    if versosDia == nil {
                        versosDia = [VersiculoDoDia]()
                    }
                    
                    versosDia.append(verso)
                }

            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        if versosDia == nil {
            return []
        } else {
            return versosDia }
    }
    
    // Verificar se existe o versículo com DATADIA NULL
    func Buscar_versiculo_dia_data_nula() -> [VersiculoDoDia] {
        var versosDia: [VersiculoDoDia]!
        
        sqlQuery = "SELECT DATADIA,LIVRO,CAPITULO,VERSICULO FROM VERSICULOSDIA WHERE DATADIA IS NULL"
        
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                while results.next() {
                    
                    let verso = VersiculoDoDia(
                        datadia: results.date(forColumn: field_data_versiculo_diario),
                                               livro: results.string(forColumn: field_livro_diario),
                                               capitulo: results.string(forColumn:  field_capitulo_diario),
                                               versiculo: results.string(forColumn: field_versiculo_diario))
                    if versosDia == nil {
                        versosDia = [VersiculoDoDia]()
                    }
                    
                    versosDia.append(verso)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        if versosDia == nil {
            return []
        } else {
            return versosDia }
    }

    
    // Atualizar o versículo com a data do dia
    func atualizarrVersiculoDoDia(datadia:String,versos:[VersiculoDoDia]) {
    
        sqlQuery = "update VERSICULOSDIA set DATADIA = '" + datadia + "' " +
        "where LIVRO = '" + versos[0].livro + "'" +
        "and CAPITULO = '" + versos[0].capitulo + "'" +
        "and VERSICULO = '" + versos[0].versiculo + "'"
        if openDatabase() {
            
            database.beginTransaction()
            
            
            if !database.executeStatements(sqlQuery) {
                print("Falha na alteraçao de versículo do dia.")
                print(database.lastError() as Any, database.lastErrorMessage() as Any)
            } else {
                database.commit()}
        }

        database.close()
    }
    
    //  Selecionar as preferencias de fonte
    func preferenciasSistema() -> [PreferenciasSistema]! {
        var prefS: [PreferenciasSistema]!
        
        sqlQuery = "SELECT * from PREFERENCIAS;"
        
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                while results.next() {
                    
                    let pref = PreferenciasSistema(
                        FonteNome: results.string(forColumn: field_Fonte),
                        FonteTamanho: results.string(forColumn: field_Tamanho),
                        FundoNoturno: results.string(forColumn: field_fundo_noturno))
                    
                    if prefS == nil {
                        prefS   = [PreferenciasSistema]()
                    }
                    
                    prefS.append(pref)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return prefS
    }
    
    // Inserir o versículo do dia
    func alterarPreferencias(fonte:String,tamanho:String, fundo_noturno:String) {
        
        
        sqlQuery = "update PREFERENCIAS set FONTENORMAL='" + fonte +
            "',TAMANHO='" + tamanho + "'" +
            ",FUNDO_NOTURNO='" + fundo_noturno + "';"
        if openDatabase() {
            
            database.beginTransaction()
            
            
            if !database.executeStatements(sqlQuery) {
                print("Falha na alteração das preferências.")
                print(database.lastError() as Any, database.lastErrorMessage() as Any)
            } else {
                database.commit()}
        }
        
        database.close()
    }
    
    // Selecionar o Livro, Capitulo e versiculo segundo os filtros
    func trazerLivroCapitulo(livro: String, capituloCorrente: String,
                             capitulo1: String,
                             capitulo2: String,
                                      versiculo1: String,
                                      versiculo2: String)->[LivroCapituloVersiculo] {
        var versoPlano: [LivroCapituloVersiculo]!
        
        // CONSULTA PELO ID DA ABREVIACAO
        sqlQuery  =
            "select B.BOOK_NAME as livro,BI.CHAPTER as capitulo, BI.TEXT as text," +
            "BI.VERSE as verse, A.BOOK_ID as book_id " +
            "FROM BOOKS B, BIBLIA BI, ABBREVIATIONS A " +
            "WHERE B.BOOK_ID = BI.BOOK_ID " +
            "AND A.BOOK_ID = B.BOOK_ID " +
            "AND A.abbreviation = '" + livro + "' "
        if (capitulo2 == "") {
            //se capitulo2 nao preenchido entao verificar se versiculos1 e versiculos2 
            //foram preenchidos. Se sim filtrar pelos versiculo1 e versiculo2
            if (versiculo1 != "") && (versiculo2 != "") {
                sqlQuery += "AND BI.CHAPTER = " + capituloCorrente + " AND " +
                    "BI.VERSE >= " +  versiculo1 + " AND BI.VERSE <= " + versiculo2
            }
            else { sqlQuery += "AND BI.CHAPTER = '" + capituloCorrente + "'" }
        }
        else {
            sqlQuery += "AND BI.CHAPTER = '" + capituloCorrente + "'"
            }
        sqlQuery += ";"
        
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                print(sqlQuery)
                while results.next() {
                    
                    let plano = LivroCapituloVersiculo(
                        livro: results.string(forColumn: field_livro_diario),
                        capítulo: results.string(forColumn: field_capitulo_diario),
                        texto: results.string(forColumn: field_text),
                        verse: results.string(forColumn: field_verse),
                        livroID: results.string(forColumn: field_livroID)
                        )
                    
                    if versoPlano == nil {
                        versoPlano   = [LivroCapituloVersiculo]()
                    }
                    
                    versoPlano.append(plano)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return versoPlano
    }

    // Atualizar o versículo com a data do dia
    func atualizarMarcacao(titulo:String,
                   livroID:String,capituloID:String,versiculoID:Int32) {
        sqlQuery = "update BIBLIA " +
            "SET DATAMARCACAO = DATETIME('NOW'),"  +
            "TITULOMARCACAO = '\(titulo)' " +
            "WHERE BOOK_ID = \(livroID)" +
            " AND CHAPTER = \(capituloID)" +
            " AND VERSE = \(versiculoID)"
        print(sqlQuery)
        if openDatabase() {
            
            database.beginTransaction()
            
            if !database.executeStatements(sqlQuery) {
                print("Falha na alteraçao de versículo do dia.")
                print(database.lastError() as Any, database.lastErrorMessage() as Any)
            } else {
                database.commit()}
        }
        
        database.close()
    }

    //Carregar as marcações ordenada pelo ano e mês
    func loadMarcacao() -> [VersosMarcados]!  {
        var versosMarcados: [VersosMarcados]!
        
        sqlQuery = "SELECT BO.BOOK_NAME as NomeLivro, BI.BOOK_ID as livroID," +
            "BI.CHAPTER as capitulo ,BI.TEXT as text,BI.VERSE as verse, " +
            "BI.DATAMARCACAO as datamarcacao,BI.TITULOMARCACAO as titulomarcacao " +
            "FROM BIBLIA BI, BOOKS BO " +
            "WHERE " +
            "BI.BOOK_ID = BO.BOOK_ID AND BI.DATAMARCACAO IS NOT NULL "  +
            "AND BI.DATAMARCACAO <> '' AND BI.TITULOMARCACAO <> '' " +
            "ORDER BY DATAMARCACAO DESC";
        print(sqlQuery)
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    
                    let marcado = VersosMarcados(
                        livroNome: results.string(forColumn: field_NameLivro),
                        livroID: results.string(forColumn: field_livro_marcacao),
                        capítulo: results.string(forColumn: field_capitulo_diario),
                        texto: results.string(forColumn: field_text),
                        verse: results.string(forColumn: field_verse),
                        titulo: results.string(forColumn: field_titulo_marcacao))
                    
                    if versosMarcados == nil {
                        versosMarcados   = [VersosMarcados]()
                    }
                    
                    versosMarcados.append(marcado)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        
        return versosMarcados;
    }
    
    // Excluir marcação indevida com a data do dia
    func excluirMarcacao( livroID:String,capituloID:String,versiculoID:String) {
        sqlQuery = "update BIBLIA " +
            "SET DATAMARCACAO = '',"  +
            "TITULOMARCACAO = '' " +
            "WHERE BOOK_ID = \(livroID)" +
            " AND CHAPTER = \(capituloID)" +
        " AND VERSE = \(versiculoID)"

        if openDatabase() {
            
            database.beginTransaction()
            
            if !database.executeStatements(sqlQuery) {
                print("Falha na exclusão de marcação.")
                print(database.lastError() as Any, database.lastErrorMessage() as Any)
            } else {
                database.commit()}
        }
        
        database.close()
    }

}
