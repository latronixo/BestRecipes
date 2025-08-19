//
//  GenericPicker.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 14.08.2025.
//

import SwiftUI

// MARK: - Generic Picker View (Row)
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
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                // MARK: - Title
                Text(title)
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // MARK: - Value
                Text(valueFormatter(selection.wrappedValue))
                    .font(.poppinsSemibold(size: 16))
                    .foregroundColor(.primary)
                
                // MARK: - Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Примеры GenericPickerView
        GenericPickerView(
            title: "Serves",
            icon: "person.2.fill",
            selection: .constant(4),
            options: Array(1...12),
            valueFormatter: { String(format: "%02d", $0) },
            action: {}
        )
        
        GenericPickerView(
            title: "Cook Time",
            icon: "clock.fill",
            selection: .constant(20),
            options: Array(stride(from: 5, to: 120, by: 5)),
            valueFormatter: { "\($0) min" },
            action: {}
        )
        
        Spacer()
    }
    .padding()
    .background(Color(.systemBackground))
}
