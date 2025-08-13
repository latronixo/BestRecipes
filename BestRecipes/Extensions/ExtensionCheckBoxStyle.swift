//
//  ExtensionCheckBoxStyle.swift
//  BestRecipes
//
//  Created by Sergey on 12.08.2025.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
//      Spacer()
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 30,height: 30)
            .foregroundColor(configuration.isOn ? .red : .black)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}
