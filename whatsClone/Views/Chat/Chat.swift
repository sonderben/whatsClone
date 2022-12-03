//
//  Chat.swift
//  whatsClone
//
//  Created by Benderson Phanor on 15/8/22.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct ChatView: View {
    @State var text=""
    var userChatPreview:UserChatPreview
    @StateObject var chatVm=ChatViewModel(userChatPreview: UserChatPreview())
    @State var proxy=1
    @State var val = ""
    @State var uiImg :UIImage?
    @State var phpImgPickerIsPresented=false
    @FocusState private var isFocused: Bool
   
    var body: some View {
        VStack{
                ScrollViewReader{ value in             
                    ScrollView{
                        LazyVStack{
                            ForEach(chatVm.messages){ message in
                                MessageItemView(message: message)
                                    .onAppear{
                                        
                                    }
                            }
                            .onChange(of: chatVm.messages.count){_ in
                                value.scrollTo("cool",anchor: .bottom)
                            }
                            Text("").id("cool")
                        }
                    }
                    /*List{
                        ForEach(chatVm.messages){ message in
                            MessageItemView(message: message)
                        }.onDelete(perform: { indexSet in
                            
                        })
                        .onChange(of: chatVm.messages.count){_ in
                            value.scrollTo("cool",anchor: .bottom)
                        }
                        Text("").id("cool")
                    }.listStyle(.plain)*/
                }
            Spacer()
            
            VStack {
                
                if uiImg != nil {
                    Image(uiImage: uiImg!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(HStack{Button(action: {uiImg=nil}, label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                        })},alignment: .topTrailing)
                        //.frame()
                }
                
                HStack{
                    Button(action: {phpImgPickerIsPresented=true}, label: {
                        HStack{
                            Image(systemName: "plus")
                        }.padding([.top,.bottom,.leading])
                    })
                    .sheet(isPresented: $phpImgPickerIsPresented) {
                         
                       //PHPImagePicker(isPresented: $phpImgPickerIsPresented, image: $uiImg)
                        ImagePicker(selectedImage: $uiImg)
                            }

                    TextField("",text: $text,axis: .vertical).padding([.trailing,.leading],5).textFieldStyle(.roundedBorder).lineLimit(nil)
                        .autocorrectionDisabled(true)
                        .focused($isFocused)

                    if(text.count>0 || uiImg != nil){
                        Button(action: {
                            
                            var msg = Message(msg: text)
                            msg.receiptEmail = userChatPreview.chatPreview?.emailRecipient ?? userChatPreview.user!.email!
                          
                            chatVm.sendMessage( message: msg,data: uiImg?.jpegData(compressionQuality: 0.5)) { msgIsSendWithSuccess in
                                text=""
                                uiImg=nil
                            }
                            
                        }, label: {
                            HStack{
                                Image(systemName: "paperplane.fill")
                            }.padding([.top,.bottom,.trailing],8)
                        })
                    }else{
                        Button(action: {}, label: {
                            HStack{
                                Image(systemName: "camera")
                            }.padding([.top,.bottom,.trailing],8)
                        })
                        Button(action: {}, label: {
                            HStack{
                                Image(systemName: "mic")
                            }.padding([.top,.bottom,.trailing],10)
                        })
                    }
                }.background(Color.blue.opacity(0.1))
            }
        }
            .navigationBarItems(leading: HStack{
                NavigationLink(destination: ShowFullScreenImage(urlImage: URL(string: userChatPreview.chatPreview?.urlImageRecipient ?? userChatPreview.user!.urlImage)), label: {
                    WebImage(url: URL(string: userChatPreview.chatPreview?.urlImageRecipient ?? userChatPreview.user!.urlImage)).resizable()
                        .frame(width: 30,height: 30)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 1)
                        }
                        .shadow(radius: 3)
                })
                
                VStack(alignment: .leading) {
                    Text((userChatPreview.chatPreview?.nameRecipient ?? userChatPreview.user?.name)!).bold()
                    Text("En Ligne").font(.caption2)
                }
                Spacer()
            })
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                chatVm.userChatPreview=userChatPreview
                if(userChatPreview.chatPreview != nil){
                    //chatVm.loadChat(withChatPreview: userChatPreview.chatPreview!)
                    chatVm.observerChat(withChatPreview: userChatPreview.chatPreview!)
                    chatVm.updateAmountUnreadMessage()
                }
                else{
                    chatVm.searchChatPreviewWithEmail_((userChatPreview.user?.email)!)
                }
               
            }
            .onTapGesture {
                hideKeyboard()
            }
    }
}

struct Chat_Previews: PreviewProvider {
    let mult=Multimedia(urlData: "",typeData: .image)
    static var previews: some View {
        MessageItemView(message: Message( msg: "sa a bel",multimedia: Multimedia(urlData: "https://static.remove.bg/remove-bg-web/3d75df900686714aa0c3f2ac38a019cdc089943e/assets/start_remove-c851bdf8d3127a24e2d137a55b1b427378cd17385b01aec6e59d5d4b5f39d2ec.png",typeData: .image)  ) )
    }
}


struct MessageItemView: View {
    var isSendByMe=false
    var message:Message
    @State var showFullScreenImage=false
    var body: some View {
        VStack{

            
            HStack{
                
                if message.isSendByMe{
                    Spacer()
                    
                }
                
                Grid(alignment: .trailing){
                    Group{
                        GridRow{
                            if message.multimedia == nil || message.multimedia!.typeData == MultimediaType.none{
                                HStack {
                                   
                                    Text(message.msg)
                                        .padding(.trailing,5)
                                        .foregroundColor(Color.white)
                                        .font(.title2)
                                }
                            }
                            else if message.multimedia!.typeData == MultimediaType.image{
                               
                                VStack(alignment:.trailing){
                                    
                                    
                                        
                                    
                                    NavigationLink(destination: ShowFullScreenImage(urlImage: URL(string:  message.multimedia!.urlData)), /*isActive: $showFullScreenImage,*/ label: {
                                        WebImage(url: URL(string: message.multimedia!.urlData))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 200)
                                            .blur(radius: 0.3)
                                    })
                                    
                                    Text(message.msg)
                                        .padding(.trailing,5)
                                        .foregroundColor(Color.white)
                                        .font(.title2)
                                       
                                }
                            }
                                
                            
                        }
                            .padding([.leading,.trailing,.top],5)
                        
                        GridRow{
                            Text(message.sendDate.prettyHM())
                                .font(.caption)
                                .foregroundColor(Color.white)
                                .padding(.trailing,10)
                                .gridColumnAlignment(.trailing)
                                .padding([.leading,.bottom],10)
                                
                            
                        }
                    }
                }.background(!message.isSendByMe ?Color.blue.opacity(0.83) : Color.black.opacity(0.83))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(5)
                    .shadow(radius: 35)
                
               
                if !message.isSendByMe{
                    Spacer()
                }
                
            }.id(message.id)
            //.padding()
            
            
        }
        .listRowSeparator(.hidden)
    }
}


struct ShowFullScreenImage:View{
    let urlImage:URL?
    var body: some View{
        VStack{
            WebImage(url: urlImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
