//
//  Chat.swift
//  whatsClone
//
//  Created by Benderson Phanor on 15/8/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ConversationList: View {
    
    @State var textSearch=""
    @State var isNewChat=false
    
    @State var userEmail=""
    @State var userUrlImage=""
    @State var userName=""
    @State var userInfo=""
    @State var userSelected = User_()
    @State var goingToChatView=false
    @StateObject var cp=ChatPreviewViewModel()
    var body: some View {
        NavigationView{
            
            VStack{

                List{
                    ForEach(cp.chatPreviews){chatPreview in
                        NavigationLink(destination: ChatView(userChatPreview: UserChatPreview(chatPreview: chatPreview)), label: {
                            ConversationItem(cp: chatPreview)
                        })
                    }
                    
                }.listStyle(PlainListStyle())
                    .searchable(text: $textSearch,prompt: "search")
                    .navigationTitle("Chats")
                    .navigationBarItems(trailing: Button(action: {
                        isNewChat=true
                        
                    }, label: {Image(systemName: "square.and.pencil")}))
                    .sheet(isPresented: $isNewChat,onDismiss: {
                        ChatPreviewViewModel().loadChatsPreview()
                        if userEmail.count>3{
                            goingToChatView=true
                            userSelected.email=userEmail
                            userSelected.urlImage=userUrlImage
                            userSelected.info=userInfo
                            userSelected.name=userName
                        }
                    }){
                        NewChat(userEmail: $userEmail, userUrlImage: $userUrlImage, userName: $userName, userInfo: $userInfo, isPresented: $isNewChat)
                        
                    }
                NavigationLink("",destination: ChatView(userChatPreview: UserChatPreview(user: userSelected) ),isActive: $goingToChatView ).disabled(true)
            }
            
        }
    }
}

struct ConversationList_Previews: PreviewProvider {
    static var previews: some View {
        //ChatItem()
        //ConversationList()
        ConversationItem(cp: ChatPreview(lastMsg: Message(msg: "sak gen nn kay la depi kek jou ui m pa tnadew sak regle menm, u jis trankil"), chatId: "ushshs", chatPreviewIdRecipient: "dd", urlImageRecipient: "https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg", emailRecipient: "fff", nameRecipient: "Benderson"))
    }
}
struct ConversationItem: View{
    var cp:ChatPreview
    var body: some View{
        HStack{
            
            
            WebImage(url: URL(string: cp.urlImageRecipient))
                .resizable()
                .frame(width: 45,height: 50)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth: 2)
                }
                .shadow(radius: 7)
            VStack{
                HStack{
                    Text(cp.nameRecipient).bold()
                        .lineLimit(1)
                    Spacer()
                    Text(cp.lastMsg.sendDate.prettyDHM_RD()).font(.caption)
                }
                HStack {
                    Text(cp.lastMsg.msg)
                        .lineLimit(2)
                    .font(.caption)
                    Spacer()
                    
                    if cp.amountUnreadMessage > 0{
                        Text("\(cp.amountUnreadMessage)")
                            .padding(3)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(13)
                            .lineLimit(1)
                    }
                    
                }
            }
        }//.frame(maxHeight: 90)
    }
}
