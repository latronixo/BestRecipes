//
//  TimePillView.swift
//  BestRecipes
//
//  Created by Наташа Спиридонова on 20.08.2025.
//

import SwiftUI

struct TimePillView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .padding(.vertical, 6)
            .padding(.horizontal,16)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.12))
                    )
            }
            .foregroundStyle(.white)
    }
}

#Preview {
    TimePillView(text: "Просмотр хронометража")
}
