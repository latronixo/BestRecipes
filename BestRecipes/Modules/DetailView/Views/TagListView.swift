//
//  TagListView.swift
//  BestRecipes
//
//  Created by Sergey on 23.08.2025.
//

import SwiftUI
import TagLayoutView

struct TagListView: View {
    var tags: [String]
    var body: some View {
        VStack {
            GeometryReader { geometry in
                TagLayoutView(
                    self.tags,
                    tagFont: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.thin),
                    padding: 1,
                    parentWidth: geometry.size.width) { tag in
                        Text(tag)
                            .bold()
                            .fixedSize()
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .foregroundColor(Color("tagTextColor"))
                            .background(Color("tagColor"))
                            .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color("tagTextColor"), lineWidth: 2.0))
                    }.padding(.all, 16)
            }
            
        }
    }
}

#Preview {
    TagListView(tags: ["Italian", "Vegan", "Korean", "Dinner", "Breakfast"])
}
