//
//  RecipeImageView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 11.08.2025.
//

import SwiftUI
import PhotosUI

// MARK: - Recipe Image View
struct RecipeImageView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: AddRecipeViewModel
    @State private var showingImagePicker = false
    @State private var selectedUIImage: UIImage?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // MARK: - Image Container
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 200)
                    .overlay(
                        Group {
                            if let imagePath = viewModel.imagePath, let uiImage = loadImage(from: imagePath) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else if let selectedUIImage = selectedUIImage {
                                Image(uiImage: selectedUIImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    
                                    Text("Add photo")
                                        .font(.poppinsRegular(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    )
                
                // MARK: - Edit Button
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                .overlay(
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                )
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedUIImage, onImageSelected: { image in
                handleImageSelection(image)
            })
        }
    }
    
    // MARK: - Private Methods
    private func handleImageSelection(_ image: UIImage?) {
        guard let image = image else { return }
        
        // Save image to app documents
        if let imagePath = saveImageToDocuments(image) {
            viewModel.selectImage(path: imagePath)
        }
    }
    
    private func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "recipe_image_\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    private func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
}

// MARK: - Preview
#Preview {
    RecipeImageView(viewModel: AddRecipeViewModel())
        .padding()
}
