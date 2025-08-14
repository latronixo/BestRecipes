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
                trailing: Button("Done") {
                    dismiss()
                }
                .font(.poppinsSemibold(size: 16))
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
            options: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 105, 120],
            valueFormatter: { "\($0) min" }
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
