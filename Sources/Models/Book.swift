import Foundation

struct Book {
    let id: String
    var title: String
    var author: String
    var filePath: String
    var coverPath: String?
    var progress: Double
    var lastRead: TimeInterval
}
