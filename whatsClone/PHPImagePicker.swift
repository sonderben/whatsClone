//
//  PHPImagePicker.swift
//  whatsClone
//
//  Created by Benderson Phanor on 28/8/22.
//

import Foundation
import PhotosUI
import SwiftUI
struct PHPImagePicker: UIViewControllerRepresentable {
    //let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        
         var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        
        controller.view.subviews
            .filter { $0.isKind(of: UINavigationBar.self) }
                    .forEach { $0.isHidden = true }
        
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: PHPImagePicker
        
        init(_ parent: PHPImagePicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            parent.isPresented = false // Set isPresented to false because picking has finished.
            
            
            guard let provider = results.first?.itemProvider else {return}
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self){image, _ in
                    self.parent.image = image as? UIImage
                }
            }
            
            
        }
    }
}
