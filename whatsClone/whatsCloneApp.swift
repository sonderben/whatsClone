//
//  whatsCloneApp.swift
//  whatsClone
//
//  Created by Benderson Phanor on 15/8/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        //try? FirebaseManager.shared.auth.signOut()
        return true    }
}

@main
struct whatsCloneApp: App {
    let persistenceController = PersistenceControler.shared
    
    
    //chv.loadChatsPreview()
    
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        //chv.loadChatsPreview()
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
                .environment(\.isUserConected, (Auth.auth().currentUser) != nil )
            //.environmentObject(userModelView)
        }
    }
}
