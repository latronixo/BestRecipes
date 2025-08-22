//
//  Coordinator.swift
//  BestRecipes
//
//  Created by Drolllted on 17.08.2025.
//

import UIKit
import SwiftUI

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let parent: ImagePicker
    
    init(parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.selectedImage = uiImage
        }
    }
    
}


