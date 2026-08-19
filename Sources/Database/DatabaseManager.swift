import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createTable()
    }
    
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("hanbooks.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
    }
    
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Books(
        Id TEXT PRIMARY KEY,
        Title TEXT,
        Author TEXT,
        FilePath TEXT,
        CoverPath TEXT,
        Progress REAL,
        LastRead REAL);
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Books table created.")
            } else {
                print("Books table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertOrUpdate(book: Book) {
        let insertStatementString = "INSERT OR REPLACE INTO Books (Id, Title, Author, FilePath, CoverPath, Progress, LastRead) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (book.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (book.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (book.author as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (book.filePath as NSString).utf8String, -1, nil)
            if let cover = book.coverPath {
                sqlite3_bind_text(insertStatement, 5, (cover as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStatement, 5)
            }
            sqlite3_bind_double(insertStatement, 6, book.progress)
            sqlite3_bind_double(insertStatement, 7, book.lastRead)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        }
        sqlite3_finalize(insertStatement)
    }
    
    func fetchAllBooks() -> [Book] {
        let queryStatementString = "SELECT * FROM Books ORDER BY LastRead DESC;"
        var queryStatement: OpaquePointer?
        var books: [Book] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(cString: UnsafePointer<CChar>(OpaquePointer(sqlite3_column_text(queryStatement, 0))))
                let title = String(cString: UnsafePointer<CChar>(OpaquePointer(sqlite3_column_text(queryStatement, 1))))
                let author = String(cString: UnsafePointer<CChar>(OpaquePointer(sqlite3_column_text(queryStatement, 2))))
                let filePath = String(cString: UnsafePointer<CChar>(OpaquePointer(sqlite3_column_text(queryStatement, 3))))
                
                var coverPath: String? = nil
                if let coverCStr = sqlite3_column_text(queryStatement, 4) {
                    coverPath = String(cString: UnsafePointer<CChar>(OpaquePointer(coverCStr)))
                }
                
                let progress = sqlite3_column_double(queryStatement, 5)
                let lastRead = sqlite3_column_double(queryStatement, 6)
                
                let book = Book(id: id, title: title, author: author, filePath: filePath, coverPath: coverPath, progress: progress, lastRead: lastRead)
                books.append(book)
            }
        }
        sqlite3_finalize(queryStatement)
        return books
    }
}
