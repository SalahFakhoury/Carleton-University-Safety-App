//
//  FirebaseManager.swift
//  uwbtestapp
//
//  Created by Arafat Hossain on 26/10/22.
//

import FirebaseDatabase

class FirebaseManager {
    private let dbRef = Database.database().reference()
    
    static let shared = FirebaseManager()

    private init() { }
    
    func storeData(data: DataInfo) {
        dbRef.child(data.path).setValue(data.dataString)
        
//        print("Path: \(data.path)")
//        print("Value: \(data.dataString)")
        
    }
}
