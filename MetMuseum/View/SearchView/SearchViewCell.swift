//
//  SearchResultCell.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 08.03.2023.
//

import SwiftUI

struct SearchViewCell: View {
    @State private var isExpanded = false
    
    let artwork: Artwork

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            image
            
            VStack (alignment: .leading, spacing: 8) {
                bottomText
                
                if isExpanded {
                    Divider()
                    
                    moreDetails
                }
            }
            .padding(.vertical)
            .transition(.move(edge: .bottom))
        }
        .frame(width: Constants.width - 48)
        .cornerRadius(3)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(.secondary, lineWidth: 0.3)
                .shadow(color: .secondary, radius: 2)
        )
    }
    
    var image: some View {
        Image(uiImage: artwork.image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: Constants.width - 48,
                   maxHeight: artwork.portraitMode ? Constants.width : artwork.height)
            .background(.secondary)
    }
    
    var bottomText: some View {
        VStack {
            HStack (alignment: .center) {
                Text("Artwork")
                Spacer()
                DownloadButton(artwork)
            }
            HStack (alignment: .bottom) {
                if let title = artwork.objectData.title {
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Title:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(title)
                            .font(.title3)
                            .padding(.top, 6)
                    }
                }
                Spacer()
                Button("More details") {
                    withAnimation(.linear(duration: 0.5)) {
                        self.isExpanded.toggle()
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
    }
    
    var moreDetails: some View {
        VStack (alignment: .leading, spacing: 6) {
            if let artistDisplayName = artwork.objectData.artistDisplayName, let artistDisplayBio = artwork.objectData.artistDisplayBio {
                Text("\(Attribute("Artist:").gray) \(artistDisplayName.isEmpty ? "Unknown" : artistDisplayName) \(artistDisplayBio.isEmpty ? "" : "(" + artistDisplayBio + ")")")
            }
            
            if let objectDate = artwork.objectData.objectDate, !objectDate.isEmpty {
                Text("\(Attribute("Date:").gray) \(objectDate)")
            }
            
            if let culture = artwork.objectData.culture, !culture.isEmpty {
                Text("\(Attribute("Culture:").gray)  \(culture)")
            }
            
            if let medium = artwork.objectData.medium, !medium.isEmpty {
                Text("\(Attribute("Medium:").gray) \(medium)")
            }

            if let dimensions = artwork.objectData.dimensions, !dimensions.isEmpty {
                Text("\(Attribute("Dimensions:").gray) \(dimensions)")

            }

            if let classification = artwork.objectData.classification, !classification.isEmpty {
                Text("\(Attribute("Classification:").gray) \(classification)")
            }

            if let creditLine = artwork.objectData.creditLine, !creditLine.isEmpty {
                Text("\(Attribute("Credit line:").gray) \(creditLine)")
            }

            if let accessionNumber = artwork.objectData.accessionNumber, !accessionNumber.isEmpty {
                Text("\(Attribute("Accession number:").gray) \(accessionNumber)")
            }
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }
}

struct SearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (spacing: 24) {
                SearchViewCell(
                    artwork: Artwork.mock())
            }
        }
    }
}
