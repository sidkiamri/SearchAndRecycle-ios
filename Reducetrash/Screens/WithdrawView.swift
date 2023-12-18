//
//  WithdrawView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct GiftCard: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

struct WithdrawView: View {
    let giftCards: [GiftCard] = [
        GiftCard(name: "Amazon", image: "amazon"),
        GiftCard(name: "steam", image: "steam"),
        GiftCard(name: "playstore", image: "playstore"),
    
     
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Withdraw")
                    .font(.largeTitle)
                    .bold()
                
                Text("Select a gift card to withdraw")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                    ForEach(giftCards) { card in
                        VStack {
                            Image(card.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                            
                            Text(card.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle(Text("Withdraw"), displayMode: .large)
    }
}


