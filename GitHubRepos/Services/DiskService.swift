//
//  DiskService.swift
//

import Foundation

class DiskService {
    
    fileprivate class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func saveToDisk<T>(data: Data, className: T.Type) {
        let fileName = getIdentifier(className)
        
        let path = getDocumentsDirectory()
        //print("saveToDisk \(path)")
        let fullPath = path.appendingPathComponent(fileName)
        //print("saveToDisk \(fullPath)")
        try? data.write(to: fullPath)
    }
    
    class func loadFromDisk<T>(className: T.Type) -> Data? {
        let fileName = getIdentifier(className)
        
        let path = getDocumentsDirectory()
        let fullPath = path.appendingPathComponent(fileName)
        if (FileManager.default.fileExists(atPath: fullPath.path)) {
            let data = try? Data(contentsOf: fullPath)
            return data
        }
        
        return nil
    }
    
    class func deleteFromDisk<T>(className: T.Type) {
        let fileName = getIdentifier(className)
        
        let path = getDocumentsDirectory()
        let fullPath = path.appendingPathComponent(fileName)
        if (FileManager.default.fileExists(atPath: fullPath.path)) {
            try? FileManager.default.removeItem(at: fullPath)
        }
    }

    
    private class func getIdentifier<T>(_ type: T.Type) -> String {
        let separator = "."
        let fullName = String(describing: type)
        if fullName.contains(separator) {
            let items = fullName.components(separatedBy: separator)
            if let name = items.last {
                return name
            }
        }
        
        return fullName
    }

}
