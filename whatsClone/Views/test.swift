//
//  test.swift
//  whatsClone
//
//  Created by Benderson Phanor on 27/8/22.
//

import SwiftUI
import SDWebImageSwiftUI

/*Hi there just wanted you know I was going out for dinner tonight with the girls so if you’re available I will bring the girls*/


struct test: View {
    var body: some View {
        VStack{
          
            List{
                item(isMe: true)
                    .listRowSeparator(.hidden)
                item(isMe: false)
                item(isMe: true)
                item(isMe: false)
                item(isMe: true)
                item(isMe: false)
            }.listStyle(.plain)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}


struct item: View {
    var isMe=true
    var body: some View {
        HStack{
            if isMe{
                Image(systemName: "chevron.backward")
                WebImage(url: URL(string: "https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg")).resizable()
                    .frame(width: 40,height: 40)
                    .clipShape( Circle())
                    .overlay {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 3,  dash: [44,21]))
                                    //.frame(width: 250, height: 100)
                                    .foregroundColor(.purple)
                       
                    }
                    .shadow(radius: 3)
                
                VStack(alignment: .leading) {
                    Text("Ben").bold()
                    Text("En Ligne").font(.caption2)
                }
                Spacer()
            }else{
                Spacer()
                Image(systemName: "chevron.backward")
                WebImage(url: URL(string: "https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg")).resizable()
                    .frame(width: 40,height: 40)
                    .clipShape( Circle())
                    .overlay {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 3,  dash: [44,21]))
                                    //.frame(width: 250, height: 100)
                                    .foregroundColor(.purple)
                       
                    }
                    .shadow(radius: 3)
                
                VStack(alignment: .leading) {
                    Text("Ben").bold()
                    Text("En Ligne").font(.caption2)
                }
            }
            
            
        }
    }
}
