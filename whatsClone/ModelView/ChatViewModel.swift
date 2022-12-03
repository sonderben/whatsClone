//
//  ChatViewModel.swift
//  whatsClone
//
//  Created by Benderson Phanor on 21/8/22.
//

import Foundation
import Firebase
class ChatViewModel: ObservableObject{
    @Published var messages:[Message]=[]
    var userChatPreview:UserChatPreview

    
    init(userChatPreview:UserChatPreview) {
        self.userChatPreview = userChatPreview
        if userChatPreview.chatPreview != nil{
            observerChat(withChatPreview: userChatPreview.chatPreview!)
            print("li execute")
        }
        
    }
    
    public func updateAmountUnreadMessage(){
        FirebaseManager.shared.firestore.collection("chatPreview").document(userChatPreview.chatPreview!.idDoc).updateData(["amountUnreadMessage":0])
        
    }
    
    public func observerChat(withChatPreview conv:ChatPreview){
        FirebaseManager.shared.firestore.collection("chats").document(conv.chatId).addSnapshotListener { documentSnapchot, error in
            if let chatSnapchot = documentSnapchot{
                let chat = try? chatSnapchot.data(as: Chat.self)
                
                if chat != nil && !chat!.messages.isEmpty{
                    self.messages=try! chatSnapchot.data(as: Chat.self).messages
                    //print(try! chatSnapchot.data(as: Chat.self))
                    self.messages.map{print($0.msg)}
                }
                
            }
        }
        
    }
    public func loadChat(withChatPreview conv:ChatPreview){
        FirebaseManager.shared.firestore.collection("chats").document(conv.chatId).getDocument { documentSnapchor, error in
            if let chatSnapchot = documentSnapchor, error==nil{
                
                let chat = try? chatSnapchot.data(as: Chat.self)
                
                if chat != nil && !chat!.messages.isEmpty{
                    self.messages=try! chatSnapchot.data(as: Chat.self).messages
                    //print(try! chatSnapchot.data(as: Chat.self))
                }
                
            }
        }
    }
    
    /*private func searchChatPreviewWithEmail(_ email:String="sonderben@gmail.com")->String?{
        var output:String?
        FirebaseManager.shared.firestore.collection("users").document(email).getDocument { documentSnapchot, error in
            if let docUser=documentSnapchot,((documentSnapchot?.exists) != nil){
                let tempRecipientUser=try? docUser.data(as: User_.self)
                if let tempRecipientUser=tempRecipientUser{
                    FirebaseManager.shared.firestore.collection("Users").document((FirebaseManager.shared.auth.currentUser?.email)!).getDocument { documentSnapchot, error in
                        if let docUser=documentSnapchot,((documentSnapchot?.exists) != nil){
                            let currentUser=try? docUser.data(as: User_.self)
                            if let currentUser = currentUser{
                                let chatsPreviewRecipient=tempRecipientUser.chatPreviewId
                                let chatsPreviewCurrentUser=currentUser.chatPreviewId
                                
                                 output = chatsPreviewRecipient!.filter{ chatsPreviewCurrentUser!.contains($0) }[0]
                            }
                        }
                    }
                }
            }
        }
        return output
    }*/
    
    public func searchChatPreviewWithEmail_(_ email:String){
        
        FirebaseManager.shared.firestore.collection("chatPreview").whereField("emailRecipient", isEqualTo: email).getDocuments(/*source: .cache*/) { querySnapchot, error in
            
            if error == nil{
                if querySnapchot?.documents.count ?? 0 > 0 {
                    let chatPreview =  try? querySnapchot?.documents[0].data(as: ChatPreview.self)
                      
                      if let chatPreview = chatPreview{
                          self.userChatPreview.chatPreview = chatPreview
                          self.loadChat(withChatPreview: chatPreview)
                      }
                }
            }
        }
    }
    
  
    public func sendMessage(message:Message)->Bool{

            if let recipient = self.userChatPreview.user, self.userChatPreview.chatPreview == nil{
                
                return sendFirstMessage(message: message, recipient: recipient)
              //
                
            }else{
                
                  return sendOthersMessage(message: message/*, chatPreview: chatPreview*/)

            }
    }
    
    public func sendMessage(message:  Message,data:Data?,completion:@escaping(_ msgIsSendWithSuccess:Bool)->Void){

        
        if let data = data{
            
            uploadData(dataName:UUID().uuidString, dataImg: data) { url in
                let multimedia =  Multimedia(urlData: url!.absoluteString,typeData: .image)
                var tempMessage = message
                tempMessage.multimedia = multimedia
                completion( self.sendMessage(message: tempMessage) )
                return
            }
        }
        else{
            completion( self.sendMessage(message: message) )
        }
       
        
        
        
        
    }
    
    
    private func sendFirstMessage(message:Message,recipient:User_)->Bool{

        

        let currentUserUrlImage = UserDefaults.standard.string(forKey: "currentUserUrlImage")!
        let currentUserName = UserDefaults.standard.string(forKey: "currentUserName")!

        var completeWithSuccess = false
            let emailCurrentUser=FirebaseManager.shared.auth.currentUser?.email
            let chat = Chat(messages: [message])
        
        let chatPreview = ChatPreview(lastMsg: message, chatId: "\(chat.id!)",chatPreviewIdRecipient:UUID().uuidString,urlImageRecipient: recipient.urlImage,emailRecipient: recipient.email!,nameRecipient: recipient.name)
        
        var chatPreviewRecipient = ChatPreview(lastMsg: message, chatId: "\(chat.id!)", chatPreviewIdRecipient: chatPreview.idDoc,urlImageRecipient: currentUserUrlImage, emailRecipient: (FirebaseManager.shared.auth.currentUser?.email)!,  nameRecipient: currentUserName)
        
        chatPreviewRecipient.idDoc=chatPreview.chatPreviewIdRecipient
        chatPreviewRecipient.id=chatPreview.chatPreviewIdRecipient
        
        do{
            try! FirebaseManager.shared.firestore.collection("message").document(message.idFireStore!).setData(from: message) { error in
                if error == nil{
                    do{
                        _ = try FirebaseManager.shared.firestore.collection("chats").document(chat.id!).setData(from: chat,completion: { error in
                            do{
                                
                                
                                ////////////////1 current user
                                _ = try! FirebaseManager.shared.firestore.collection("chatPreview").document(chatPreview.id!).setData(from: chatPreview,completion: { error in
                                    if(error == nil){


                                        FirebaseManager.shared.firestore.collection("users").document(emailCurrentUser!).updateData( ["chatPreviewId":FieldValue.arrayUnion([chatPreview.id!]) ]) { recipientError in
                                            
                                            
                                           
                                            
                                            
                                            
                                            _ = try! FirebaseManager.shared.firestore.collection("chatPreview").document(chatPreviewRecipient.id!).setData(from: chatPreviewRecipient,completion: { error in
                                                if(error == nil){


                                                    FirebaseManager.shared.firestore.collection("users").document(recipient.email!).updateData( ["chatPreviewId":FieldValue.arrayUnion([chatPreviewRecipient.id!]) ]) { recipientError in
                                                        
                                                        self.userChatPreview.chatPreview = chatPreview
                                                        self.messages.append(message)
                                                        //self.observerChat(withChatPreview: chatPreview) //must here
                                                        completeWithSuccess=true
                                                        
                                                    }
                                                    

                                                }
                                            })//////
                                            
                                            
                                            
                                        }
                                        

                                    }
                                })//////
                                
                                
                                
                                
                                
                                
                            }
                            
                        })
                    }catch{
                        
                    }
                }
            }
        }
        
        
        
        return completeWithSuccess
    }
    private func sendOthersMessage(message:Message/*,chatPreview:ChatPreview*/)->Bool{
        var completeWithSucces=false
        
        let a = try! Firestore.Encoder().encode(message)
        FirebaseManager.shared.firestore.collection("chats").document(userChatPreview.chatPreview!.chatId /*chatPreview.chatId*/).updateData([
            "messages": FieldValue.arrayUnion([a])
        ]) { error in
            if error == nil{
                
                
                //FirebaseManager.shared.firestore.collection("users").document(emailCurrentUser!).updateData( ["chatPreviewId":FieldValue.arrayUnion([chatPreview.id!]) ]) { recipientError in
                

                completeWithSucces=true
                
                FirebaseManager.shared.firestore.collection("chatPreview").document(self.userChatPreview.chatPreview!.idDoc).updateData(["lastMsg":a])
                
                
                
                
                FirebaseManager.shared.firestore.collection("chatPreview").document(self.userChatPreview.chatPreview!.chatPreviewIdRecipient).updateData(["lastMsg":a])
                
                if message.isSendByMe{
                    FirebaseManager.shared.firestore.collection("chatPreview").document(self.userChatPreview.chatPreview!.chatPreviewIdRecipient).updateData(["amountUnreadMessage":FieldValue.increment(Int64(1))])
                }else{
                    FirebaseManager.shared.firestore.collection("chatPreview").document(self.userChatPreview.chatPreview!.idDoc).updateData(["amountUnreadMessage":FieldValue.increment(Int64(1))])
                }
                
                
                self.messages.append(message)
                
                
                
                
            }
            else{
                //completion(false)
                completeWithSucces=false
            }
        }
        
        return completeWithSucces
    }
}



//(message:Message,completion:@escaping(_ msgIsSendWithSuccess:Bool)

func uploadData(dataName:String,dataImg:Data?,handler:@escaping(URL?)->Void){
    //var urlImg:URL?
    let storage=FirebaseManager.shared.storage
    let storageRef=storage.reference().child("message_data/\(dataName)")

    let metadata = FirebaseManager.shared.metadataImgJpg
    metadata.contentType = "image/jpg"
    
    if let dataImg = dataImg {
        storageRef.putData(dataImg,metadata: metadata, completion: {StorageMetadata,error in
            if error != nil{
                print("ocurrio un error\(error)")
                handler(nil)
                return
            }
            storageRef.downloadURL(completion: {url,error in
                if url != nil{

                    handler(url)
                    return
                }else{
                    print("myerror: \(String(describing: error))")
                }
            })
        })
    }
    
   
    
}
