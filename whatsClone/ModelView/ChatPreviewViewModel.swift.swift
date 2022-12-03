//
//  ChatPreviewViewModel.swift.swift
//  whatsClone
//
//  Created by Benderson Phanor on 22/8/22.
//

import Foundation
class ChatPreviewViewModel: ObservableObject{
    @Published var chatPreviews:[ChatPreview]=[]
    var chatsPreviewId:[String]=[]
    
    init() {
        loadChatsPreview()
    }
    
    public func loadChatsPreview(){
        if chatsPreviewId.count>0{
            loadChatsPreviewWhenChatViewChange()
        }
        FirebaseManager.shared.firestore.collection("users").document((FirebaseManager.shared.auth.currentUser?.email)!).addSnapshotListener { docSnapchot, error in
            if let docSnapchot = docSnapchot{
                if docSnapchot.exists,error == nil{
                    //try? FirebaseManager.shared.auth.signOut()
                    let user = try! docSnapchot.data(as: User_.self)
                    if let cpId = user.chatPreviewId {
                        self.chatsPreviewId = cpId
                        self.loadChatsPreviewWhenChatViewChange()
                    }
                }
            }
        }
        
        

    }
    
    private func loadChatsPreviewWhenChatViewChange(){
        FirebaseManager.shared.firestore.collection("chatPreview").whereField("idDoc", in: chatsPreviewId).addSnapshotListener { querySnapchot, error in
           
            guard error == nil else {
                            return
                          }
                          
                          guard let unwrapped = querySnapchot else {
                            return
                          }
            
            self.chatPreviews = unwrapped.documents.map{try! $0.data(as: ChatPreview.self)}
            print(self.chatPreviews)
        }
    }
}
