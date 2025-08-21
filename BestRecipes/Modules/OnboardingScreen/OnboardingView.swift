//
//  OnboardingView.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding: Bool
    @State private var showContent: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("backOnboardingImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                
                VStack(alignment: .center, spacing: 40) {
                    HStack(alignment: .center, spacing: 4){
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                        
                        Text("100k+ Premium Recipes")
                            .font(.poppinsRegular(size: 18))
                            .foregroundStyle(.white)
                            .opacity(showContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 3.0), value: showContent)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .center){
                            Text("Best")
                                .offset(y: 10)
                            Text("Recipes")
                        }
                        .font(.poppinsSemibold(size: 56))
                        .foregroundStyle(.white)
                        .bold()
                        
                        Text("Find best recipes for cooking")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 2.0), value: showContent)
                    
                    NavigationLink(destination: {
                        MainOnboardingPage(shouldShowOnboarding: $shouldShowOnboarding)
                    }, label: {
                        Text("Get Started")
                            .font(.poppinsSemibold(size: 18))
                            .foregroundStyle(Color.white)
                            .bold()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 300, height: 50)
                            }
                            .padding()
                            .opacity(showContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 2.0), value: showContent)
                    })
                    
                    
                }
                .padding()
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                withAnimation {
                    showContent = true
                }
            }
        }
    }
}

//#Preview{
//    OnboardingView()
//}
