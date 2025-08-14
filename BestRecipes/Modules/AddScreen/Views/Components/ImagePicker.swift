//
//  ImagePicker.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    
    // MARK: - Properties
    @Binding var selectedImage: UIImage?
    let onImageSelected: (UIImage?) -> Void
    @State private var selectedItem: PhotosPickerItem?
    
    // MARK: - Body
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack(spacing: 12) {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                
                Text("Select image")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                        onImageSelected(image)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("ImagePicker Preview")
            .font(.title)
            .padding()
        
        ImagePicker(
            selectedImage: .constant(nil),
            onImageSelected: { _ in }
        )
        
        Text("Now this is a completely SwiftUI component!")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
    }
    .background(Color(.systemBackground))
}