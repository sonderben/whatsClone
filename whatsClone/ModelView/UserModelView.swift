//
//  UserModelView.swift
//  whatsClone
//
//  Created by Benderson Phanor on 21/8/22.
//

import Foundation
import SwiftUI
import FirebaseAuth

class UserModelView: ObservableObject{
    @Published var isUserConnected=false
    @Published var currentUser:User_?
    @Published var userError=""
    var terminateLoad=false
    var firebaseAuth=FirebaseManager.shared.auth
    //let changeRequest = FirebaseManager.shared.auth.currentUser?.createProfileChangeRequest()
    
    init(isUserConnecter: Bool) {
        self.isUserConnected = firebaseAuth.currentUser != nil
        if self.isUserConnected{
            self.currentUser=User_()
            //currentUser?.email=(firebaseAuth.currentUser?.email)!
            loadCurrentUser(withEmail: (firebaseAuth.currentUser?.email)!)
        }
        
    }
    
    func signUp(name:String,email:String,password:String,imgData:Data?){
        firebaseAuth.createUser(withEmail: email, password: password,completion: {Result,error in
            if Result != nil{
                self.currentUser=User_()
                
                self.currentUser?.email=email

                let tempU = User_(name: name,urlImage:"unkwon", info: "hi there, i am using whatsClone")
                
                 
                try? FirebaseManager.shared.firestore.collection("users").document(email).setData(from: tempU) { error in
                    if error==nil{
                        UserDefaults.standard.set(name, forKey: "currentUserName")
                        self.uploadImage(imgName: email, dataImg: imgData)
                        
                    }else{
                        self.userError="Imposible to save user in firestore \(error)"
                    }
                }
            }else{
                self.userError="Imposible to Sign up, Auth fireStore"
            }
        })
        
    }
    
    func signIn(email:String,password:String){
        firebaseAuth.signIn(withEmail: email, password: password,completion: {Result,error in
            if Result != nil{
                
                self.loadCurrentUser(withEmail: email)
                UserDefaults.standard.set(self.currentUser?.name, forKey: "currentUserName")
                UserDefaults.standard.set(self.currentUser?.urlImage, forKey: "currentUserUrlImage")
                
            }else{
                self.userError="Imposible to Sign in"
            }
        })
        
    }
    func signOut(){
        if (isUserConnected){
            try! firebaseAuth.signOut()
            currentUser=nil
            isUserConnected=false
        }
        
    }
    
    func uploadImage(imgName:String,dataImg:Data?)->URL?{
        var urlImg:URL?
        let storage=FirebaseManager.shared.storage
        let storageRef=storage.reference().child("images/\(imgName)")
        //let data=img.jpegData(compressionQuality: 0.5)
        let metadata = FirebaseManager.shared.metadataImgJpg
        metadata.contentType = "image/jpg"
        
        if let dataImg = dataImg {
            storageRef.putData(dataImg,metadata: metadata, completion: {StorageMetadata,error in
                if error != nil{
                    self.userError="Imposible to save image"
                    print("aaa\(String(describing: error))")
                    return
                }
                storageRef.downloadURL(completion: {url,error in
                    if url != nil{
                        self.currentUser?.urlImage=url!.absoluteString
                        urlImg=url
                        self.isUserConnected=true
                        FirebaseManager.shared.firestore.collection("users").document(imgName).updateData(["urlImage":url!.absoluteString])
                        UserDefaults.standard.set(url?.absoluteString, forKey: "currentUserUrlImage")
                        return
                    }else{
                        print("myerror: \(String(describing: error))")
                    }
                })
            })
        }
        
        return urlImg
        
    }
    
    
    func loadCurrentUser(withEmail email:String){
    

        let docRef =  FirebaseManager.shared.firestore.collection("users").document(email)

        docRef.getDocument { (document, errord) in

            if let document = document, document.exists {
                do{
                    self.currentUser =  try document.data(as: User_.self)
                    self.isUserConnected=true
                    
                    //dwe nn sign in
                    UserDefaults.standard.set(self.currentUser?.name, forKey: "currentUserName")
                    UserDefaults.standard.set(self.currentUser?.urlImage, forKey: "currentUserUrlImage")
                    
                    
                }catch{
                    print("Document does not exist\(error)")
                }
                
    
            } else {
                print("Document does not exist")
            }
        }

        
    }
}
