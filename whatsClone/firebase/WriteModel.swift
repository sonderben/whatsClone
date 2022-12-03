//
//  WriteModel.swift
//  whatsClone
//
//  Created by Benderson Phanor on 16/8/22.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUI
class WriteModel: ObservableObject{
    //var ref=Database.database(url: "https://whatsclone-fe78a-default-rtdb.firebaseio.com/").reference()
    var ref2=Firestore.firestore()
    
   
    func searchUser(withEmail email:String, completion:@escaping(User_?)->Void){
        ref2.collection("users").document(email).getDocument { userSnapchot, error in
            if let user = userSnapchot{
                let user=try? user.data(as: User_.self)
                print("curr \(user)")
                completion(user)
            }
        }
    }
    
    
    
    func signup (email:String,name:String,pwd:String,img:UIImage?,completion:@escaping(Bool)->Void){
        Auth.auth().createUser(withEmail: email, password: pwd,completion: {result,error in
            //print("m pa nil\(String(describing: error))")
            
            let u=User_(email:email, name: "genial haza")
            let tempUser=["name":u.name,"info":u.info,"urlImage":"j4.com"]
            
            if error == nil{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    
                }

                if let img = img {
                    self.uploadImage(imgName: email, img: img)
                }
                
                self.ref2.collection("users").document(email).setData(tempUser, merge: false) { errror in
                    if errror==nil{
                        completion(true)
                        return
                    }
                    completion(false)
                }
                //
                return
            }
            //result?.credential?.provider.
            completion(false)
        })
    }
    
    func signIn (email:String,pwd:String,completion:@escaping(Bool)->Void){
        Auth.auth().signIn(withEmail: email, password: pwd,completion: {result,error in
            //print("m pa nil\(String(describing: error))")
            //let u=User_(email:email, name: "")
            if error == nil{
                
                //u.name = Auth.auth().currentUser?.displayName
                
                
                completion(true)
                return
            }
            //result?.credential?.provider.
            completion(false)
        })
        
    }
    
    func uploadImage(imgName:String,img:UIImage){
        let storage=Storage.storage()
        let storageRef=storage.reference().child("images/\(imgName)")
        let data=img.jpegData(compressionQuality: 0.5)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data,metadata: metadata, completion: {StorageMetadata,error in
                if error != nil{
                    print(error!)
                }
                
            })
        }
    }
    
}


