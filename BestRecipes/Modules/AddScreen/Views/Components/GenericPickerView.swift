//
//  GenericPickerView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//

import SwiftUI

// MARK: - Generic Picker View
struct GenericPickerView<T: Hashable>: View {
    
    // MARK: - Properties
    let title: String
    let icon: String
    let selection: Binding<T>
    let options: [T]
    let valueFormatter: (T) -> String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // MARK: - Icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                // MARK: - Title
                Text(title)
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                // MARK: - Value
                Text(valueFormatter(selection.wrappedValue))
                    .font(.poppinsSemibold(size: 16))
                    .foregroundColor(.black)
                
                // MARK: - Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Пример для порций
        GenericPickerView(
            title: "Serves",
            icon: "person.2.fill",
            selection: .constant(4),
            options: Array(1...12),
            valueFormatter: { String(format: "%02d", $0) },
            action: {}
        )
        
        // Пример для времени приготовления
        GenericPickerView(
            title: "Cook Time",
            icon: "clock.fill",
            selection: .constant(20),
            options: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 105, 120],
            valueFormatter: { "\($0) min" },
            action: {}
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
