//
//  PersonView.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct PersonView: View {
    @State private var avatarImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Avatar Section
                    HStack {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    MyRecipesView()
                    
                    Spacer()
                }
            }
            .toolbar {
                Text("My Profile")
                    .font(.poppinsSemibold(size: 24))
                    .foregroundStyle(.black)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $avatarImage)
            }
            .onAppear {
                loadAvatar()
            }
            .onChange(of: avatarImage) { newImage in
                saveAvatar(newImage)
            }
        }
    }
    
    private func loadAvatar() {
        if let data = UserDefaults.standard.data(forKey: "userAvatar"),
           let image = UIImage(data: data) {
            avatarImage = image
        }
    }
    
    private func saveAvatar(_ image: UIImage?) {
        guard let image = image,
              let data = image.jpegData(compressionQuality: 0.8) else {
            UserDefaults.standard.removeObject(forKey: "userAvatar")
            return
        }
        UserDefaults.standard.set(data, forKey: "userAvatar")
    }
}

#Preview {
    PersonView()
}
