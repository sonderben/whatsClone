//
//  ContentView.swift
//  whatsClone
//
//  Created by Benderson Phanor on 15/8/22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var tabItemSelection=1
    @State var email="sonderben@gmail.com"
    @State var pwd="123456"
    @State var name=""
    @State var pickerSelected=0
    @State var isPicherImageVisible=false
    @State var uiImage: UIImage?
    @State var image: UIImage?
    @State var isAnimatingActivityIndicator=false
    @Environment(\.isUserConected) private var isUserConected
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity:User.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var users: FetchedResults<User>
    

    @StateObject var userMv=UserModelView(isUserConnecter: false)
    
    
    var body: some View{
        if userMv.isUserConnected{
            TabView(selection: $tabItemSelection){
                Status()
                    .tabItem{
                        Text("Estado")
                        Image(systemName: "person.2.crop.square.stack.fill")
                    }.tag(0)
                ConversationList()
                    .tabItem{
                        Text("Chat")
                        Image(systemName: "message.fill")
                    }.tag(1)
                Setting()
                    .environmentObject(userMv)
                    .tabItem{
                        Text("Configuracion")
                        Image(systemName: "slider.vertical.3")
                    }.tag(2)
            }//.environmentObject(userMv)
        }else{
            VStack(spacing: 15){
                
              
                Text("\(userMv.userError)").lineLimit(0)
                Picker(selection: $pickerSelected, label: Text("Select Background")) {
                                        Text("Conectarse").tag(0)
                                        Text("Inscribirse").tag(1)
                    
                }.pickerStyle(.segmented)
                //Text("\(userMv.userError)")
                Group{
                    if pickerSelected == 1{
                        Button(action: {isPicherImageVisible=true}, label: {
                            Group{
                                if uiImage == nil{
                                    Image(systemName: "person")
                                        .resizable()
                                    
                                }else{
                                    Image(uiImage: uiImage!)
                                        .resizable()
                                }
                            }//
                                .frame(width: 90,height: 90)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.gray, lineWidth: 4)
                                }
                                .shadow(radius: 7)
                        })
                        
                        
                        TextField("Name",text: $name)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.words)
                    }
                    TextField("Email",text: $email)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                TextField("Password",text: $pwd)
                   
                }.textFieldStyle(.roundedBorder)
                ActivityIndicator(isAnimating: /*.constant(true)*/$isAnimatingActivityIndicator, style: .large)
                HStack{
                    if pickerSelected == 1{
                        Button(action: {
                            isAnimatingActivityIndicator=true
                            userMv.signUp(name: name, email: email, password: pwd, imgData: uiImage?.jpegData(compressionQuality: 0.5))
                            
                            if userMv.isUserConnected{
                                isAnimatingActivityIndicator=false
                            }
                            
                            
                        }, label: {
                            Text("Inscribirse")
                        })
                    }else{
                        Button(action: {
                            userMv.signIn(email: email, password: pwd)
                             
                        }, label: {
                            Text("Conectarse")
                        })
                    }
                    
                }
            }.frame(maxWidth:UIScreen.main.bounds.width*0.80)
                .sheet(isPresented: $isPicherImageVisible){
                    
                        ImagePicker(selectedImage: $uiImage)
                    
                    
                }
        }
    }
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
    private func sign_up(){
        withAnimation{
            let user = User(context: viewContext)
            user.email=email//u.email
            user.password=pwd
            user.name=Auth.auth().currentUser?.displayName!
            user.id=UUID()
            user.info=User_().info
            saveContext()
        }
   
}
    //
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
/*
 var body: some View {
     VStack {
         Image(systemName: "globe")
             .imageScale(.large)
             .foregroundColor(.accentColor)
         Text("Hello, world!")
     }
 }
 */
