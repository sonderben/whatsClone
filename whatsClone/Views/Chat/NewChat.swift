//
//  NewChat.swift
//  whatsClone
//
//  Created by Benderson Phanor on 16/8/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewChat: View {
    var wm=WriteModel()
    @State var txtSearch="sonderben@gmail.com"
    @State var userEmail_=""
    
    @Binding var userEmail:String
    @Binding var userUrlImage:String
    @Binding var userName:String
    @Binding var userInfo:String
    
    @Binding var isPresented:Bool
    
    var body: some View {
        VStack{
            HStack{
                TextField("Search",text: $txtSearch)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        
                        wm.searchUser(withEmail: txtSearch, completion: {user_ in
                            if let user_ = user_{
                                self.userEmail_=user_.email!
                               //
                                userName=user_.name
                                userUrlImage=user_.urlImage
                                userInfo=user_.info
                                userEmail=user_.email!
                            }
                        })
                    }
                    
            }
            .padding()
          
            if userUrlImage.count > 3 {
                Button(action: {isPresented=false}, label: {
                    HStack{
                        WebImage(url: URL(string: userUrlImage))
                            .resizable()
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                        VStack(alignment: .leading){
                            Text(userEmail)
                                .bold()
                            Text(userInfo).lineLimit(2)
                                .font(.callout)
                        }
                        Spacer()
                            
                    }.frame(width: UIScreen.main.bounds.width * 0.95)
                    .padding(5)
                        .background(Color.blue.opacity(0.3))
                })
            }
            
                
            
            Spacer()
        }//.frame(width: UIScreen.main.bounds.width)
    }
}

struct ItemNewChat:View{
    var body: some View{
        HStack{
            WebImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg"))
                .resizable()
                .frame(width: 60,height: 60)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text("Benderson Phanor")
                    .bold()
                Text("Hey there i am using whatsclone, i suggest you, to use it. blhef fhe uere uiewru ueire").lineLimit(2)
                    .font(.callout)
            }
                
        }.padding(5)
            .background(Color.blue.opacity(0.3))
    }
}

struct NewChat_Previews: PreviewProvider {
    static var previews: some View {
        ItemNewChat()
    }
}

