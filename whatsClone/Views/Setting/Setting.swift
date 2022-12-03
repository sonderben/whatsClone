//
//  Setting.swift
//  whatsClone
//
//  Created by Benderson Phanor on 16/8/22.
//

import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct Setting: View {
    @State var txtField=""
    @State var showingAlert=false
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var userMv:UserModelView
    
    
   
    @FetchRequest(entity:User.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var users: FetchedResults<User>
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Button(action: {
                        showingAlert=true
                        print("user url img \(userMv.currentUser!.urlImage)")
                    }, label: {
                        if userMv.isUserConnected{
                            HStack{
                                Button(action: {}, label: {
                                    WebImage(url: URL(string: userMv.currentUser?.urlImage ?? "unknow"))
                                        .resizable()
                                        .frame(width: 60,height: 60)
                                        .clipShape(Circle())
                                  }).padding()
                                    
                                    
                                VStack(alignment: .leading){
                                    Group{
                                        Text(userMv.currentUser?.email ?? "unknow")
                                        Text(userMv.currentUser?.info ?? " unknow").font(.caption)
                                    }.lineLimit(1)
                                }
                                Spacer()
                                
                                    
                            }.background(Color.gray.opacity(0.5))
                        }
                    }).alert("Deconectarse",isPresented: $showingAlert){
                        Button("Ok") {
                            deconectarse()
                            showingAlert=false
                            
                        }.environment(\.isUserConected, false)
                        Button("Cancel") {
                            showingAlert=false
                            
                        }
                    }
                }
            }.navigationTitle("Configuración")
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
    
    private func deconectarse(/*offsets: IndexSet*/) {
        withAnimation {
            userMv.signOut()
            
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}

