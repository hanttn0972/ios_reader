import Foundation
import ZIPFoundation

class EPUBParser: NSObject, XMLParserDelegate {
    
    enum EPUBError: Error {
        case fileNotFound
        case unzipFailed
        case containerNotFound
        case opfNotFound
    }
    
    private var currentElement = ""
    private var rootFilePath: String?
    
    /// Giải nén EPUB vào thư mục tạm và trả về đường dẫn tới file OPF (chứa metadata)
    func extractAndLocateOPF(epubURL: URL, completion: @escaping (Result<(String, URL), Error>) -> Void) {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        do {
            try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)
            
            // Giải nén file EPUB
            try fileManager.unzipItem(at: epubURL, to: tempDir)
            
            // 1. Tìm META-INF/container.xml
            let containerURL = tempDir.appendingPathComponent("META-INF/container.xml")
            guard fileManager.fileExists(atPath: containerURL.path) else {
                completion(.failure(EPUBError.containerNotFound))
                return
            }
            
            // 2. Phân tích container.xml để tìm file OPF (chứa Mục lục & thông tin sách)
            if let parser = XMLParser(contentsOf: containerURL) {
                parser.delegate = self
                parser.parse()
            }
            
            guard let opfPath = rootFilePath else {
                completion(.failure(EPUBError.opfNotFound))
                return
            }
            
            completion(.success((opfPath, tempDir)))
            
        } catch {
            completion(.failure(EPUBError.unzipFailed))
        }
    }
    
    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "rootfile" {
            if let fullPath = attributeDict["full-path"] {
                self.rootFilePath = fullPath
            }
        }
    }
}
