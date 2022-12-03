//
//  Message.swift
//  whatsClone
//
//  Created by Benderson Phanor on 16/8/22.
//

import Foundation
//import FirebaseDatabase
import FirebaseFirestoreSwift
//import FirebaseFirestore

struct Message: Codable,Identifiable{
    @DocumentID
    var idFireStore=UUID().uuidString
    var id=UUID()
    var sendDate=Date()
    var msg=""
    var multimedia:Multimedia?
    //var senderEmail=FirebaseManager.shared.auth.currentUser?.email
    var receiptEmail=""
    var readers:[Readers]=[]

}

extension Message{
    var isSendByMe:Bool{
        self.receiptEmail != FirebaseManager.shared.auth.currentUser?.email
    }
}


struct ChatPreview: Codable,Identifiable{
    @DocumentID
    var id=UUID().uuidString
    var idDoc:String
    var lastMsg:Message
    var chatId:String
    var emailRecipient:String
    var nameRecipient:String
    var chatPreviewIdRecipient:String
    var urlImageRecipient:String
    var amountUnreadMessage:Int=0
   
    
    init(  lastMsg: Message, chatId: String, chatPreviewIdRecipient: String,urlImageRecipient:String,emailRecipient:String,nameRecipient:String,amountUnreadMessage:Int=0) {
        self.idDoc = ""
        self.lastMsg = lastMsg
        self.chatId = chatId
        self.chatPreviewIdRecipient=chatPreviewIdRecipient
        self.urlImageRecipient=urlImageRecipient
        self.emailRecipient=emailRecipient
        self.nameRecipient=nameRecipient
        self.amountUnreadMessage=amountUnreadMessage
        self.idDoc = id!
    }
    
   
}

struct Statut :Codable{
    var dateAdd=Date()
    var msg:String
    var urlMultimedia:[String]?
}

struct Multimedia: Codable{
    var urlData:String
    var typeData:MultimediaType = .none
}

enum MultimediaType: Codable{
    case video
    case audio
    case image
    case none
}


public struct User_:Codable{
    @DocumentID
    var email=""
    var name=""
    var urlImage="url"
    var info="hay there i am using whatsCloneApp"
    var statuts:[Statut]?
    var chatPreviewId:[String]?
    var friendsId:[Int]?

}

struct Chat: Codable{
    @DocumentID
    var id=UUID().uuidString
    var messages:[Message]
}



struct Readers: Codable{
    var viewed=Date()
    var delivered=Date()
    var receiptEmail:String
}
