//
//  ImagePicker.swift
//  BestRecipes
//
//  Created by Drolllted on 17.08.2025.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
