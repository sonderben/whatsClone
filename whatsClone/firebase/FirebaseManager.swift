//
//  FirebaseManager.swift
//  whatsClone
//
//  Created by Benderson Phanor on 21/8/22.
//

import Foundation
import Firebase
import FirebaseStorage
class FirebaseManager{
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let metadataImgJpg = StorageMetadata()

    static let shared = FirebaseManager()
    

     private init() {
       // FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage=Storage.storage()
         self.firestore=Firestore.firestore()
    }
}
