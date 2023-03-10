//
//  SearchResultCell.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 08.03.2023.
//

import SwiftUI

struct SearchResultCell: View {
    let artwork: Artwork?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            if let artwork = artwork {
                HStack {
                    Image(uiImage: artwork.image)
                        .resizable()
                        .scaledToFit()
                }
                .background(Color.themeDarkGray)
                VStack (alignment: .leading, spacing: 8) {
                    Text("Artwork")
                    
                    Text(artwork.objectData.title ?? "")
                        .font(.title2)
                        .padding(.bottom, 12)
                    
                    HStack (alignment: .bottom) {
                        VStack (alignment: .leading) {
                            Text("Date: \(artwork.objectData.objectDate ?? "")")
                                .font(.subheadline)
                            
                            Text("Medium: \(artwork.objectData.medium ?? "")")
                                .font(.subheadline)
                        }
                         
                        Spacer()
                        
                        SavePhotoButton(artwork)
                    }
                }
                .foregroundColor(Color.themeGray)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 48)
        .cornerRadius(22)
        .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.themeDarkGray, lineWidth: 2)
            )
    }
}

struct SearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCell(artwork: Artwork(
            id: 1,
            image: UIImage(named: "defaultArtworkImage")!,
            objectData: Object(additionalImages: []))
        )
    }
}
