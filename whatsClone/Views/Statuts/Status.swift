//
//  Status.swift
//  whatsClone
//
//  Created by Benderson Phanor on 15/8/22.
//

import SwiftUI

struct Status: View {
    @State var textSearch=""
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Section(){
                        MyStatus()
                    }
                    Section(header: Text("Recientes")){
                        ForEach(1..<5){_ in
                            StatusItem()
                        }
                    }
                    Section(header: Text("Vistos")){
                        ForEach(1..<11){_ in
                            StatusItem()
                        }
                    }
                    Section(header: Text("Silenciados")){
                        ForEach(1..<2){_ in
                            StatusItem()
                        }
                    }
                    
                }
                .listStyle(.grouped)
                .navigationTitle("Estados")
                .searchable(text: $textSearch,prompt: "Buscar")
            }
        }
    }
}

struct Status_Previews: PreviewProvider {
    static var previews: some View {
        Status()
        //StatusItem()
    }
}

struct MyStatus:View{
    var body: some View{
        HStack{
            Button(action: {}, label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 40,height: 40)
                    .clipShape(Circle())
                    .overlay(HStack{
                        Image(systemName: "plus.circle.fill")
                            //.frame(width: 10,height: 10)
                            .foregroundColor(Color.blue)
                    },alignment: .bottomTrailing)
            })
                
            VStack(alignment: .leading){
                Text("Mi estado")
                Text("Anadir a mi estado")
            }
            Spacer()
            Image(systemName: "camera.fill")
            Image(systemName: "pencil")
                
        }
    }
}
struct StatusItem: View{
    var body: some View{
        HStack{
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 40,height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text("person Name").bold()
                Text("hace 12 horas").font(.caption)
            }
            Spacer()
        }//.frame(maxHeight: 90)
    }
}
