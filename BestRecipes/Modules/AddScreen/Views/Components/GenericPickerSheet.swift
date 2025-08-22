//
//  GenericPickerSheet.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 15.08.2025.
//


import SwiftUI

struct GenericPickerSheet<T: Hashable>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let selection: Binding<T>
    let options: [T]
    let valueFormatter: (T) -> String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(title)
                    .font(.poppinsSemibold(size: 20))
                    .padding(.top, 20)
                
                Picker(title, selection: selection) {
                    ForEach(options, id: \.self) { option in
                        Text(valueFormatter(option))
                            .font(.poppinsRegular(size: 18))
                            .tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
            }
            .navigationBarItems(
                trailing:
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.poppinsSemibold(size: 16))
                            .foregroundColor(.primary)
                    }
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Пример для порций
        GenericPickerSheet(
            title: "Select Servings",
            selection: .constant(4),
            options: Array(1...12),
            valueFormatter: { "\($0)" }
        )
        
        // Пример для времени приготовления
        GenericPickerSheet(
            title: "Select Cook Time",
            selection: .constant(20),
            options: Array(stride(from: 5, to: 120, by: 5)),
            valueFormatter: { "\($0) min" }
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
