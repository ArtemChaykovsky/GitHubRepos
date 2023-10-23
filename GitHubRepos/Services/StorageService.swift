//
//  StorageService.swift
//

import UIKit
import Foundation

struct PinCodeInfo: Codable {
    let serial: String
    let pin: String
}

class StorageService {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    static let shared = StorageService()

    var favouriteItems: [RepoItem] = []
    
    init() {

        //appSettigns
        favouriteItems = loadInfo(className: [RepoItem].self) ?? []
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillExitOrBackground), name: UIApplication.willTerminateNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillExitOrBackground), name: UIApplication.didEnterBackgroundNotification,object: nil)
    }
    
    @objc func applicationWillExitOrBackground(notification: Notification) {
        saveInfoToDisk()
    }
    
    func save(item: RepoItem) {
        if favouriteItems.contains(where: {$0.id == item.id}) {
            return
        }
        favouriteItems.append(item)
        saveInfoToDisk()
    }
    
    func delete(item: RepoItem) {
        favouriteItems.removeAll(where: {$0.id == item.id})
        saveInfoToDisk()
    }
    
    func isSaved(item: RepoItem) -> Bool {
        return favouriteItems.contains(where: {$0.id == item.id})
    }
}

//MARK: Save/Load routine
extension StorageService {
    
    private func saveInfoToDisk() {
        print("saveInfoToDisk")
        saveInfo(object: favouriteItems, className: [RepoItem].self)
    }
    
    private func saveInfo<T : Codable>(object: T?, className: T.Type) {
        guard let object = object else { //object is nil, so delete from disk
            DiskService.deleteFromDisk(className: className)
            return
        }
        
        //save to disk
        if let data = try? encoder.encode(object) {
            DiskService.deleteFromDisk(className: className) // delete previous value
            DiskService.saveToDisk(data: data, className: className)
        }
    }
    
    private func loadInfo<T : Codable>(className: T.Type) -> T? {
        
        print("loadInfo \(String(describing: className))")
        
        //load from disk
        if let objectData = DiskService.loadFromDisk(className: className), let objectModel = try? decoder.decode(className, from: objectData) {
            return objectModel
        }
        
        return nil
    }
}
