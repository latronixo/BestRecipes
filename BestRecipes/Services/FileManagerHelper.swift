//
//  FileManagerHelper.swift
//  BestRecipes
//
//  Created by Валентин on 22.08.2025.
//

import UIKit
import Foundation

class FileManagerHelper {
    static let shared = FileManagerHelper()
    private init() {}
    
    func saveImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = self.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    func loadImage(from fileName: String) -> UIImage? {
        let fileURL = self.getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
