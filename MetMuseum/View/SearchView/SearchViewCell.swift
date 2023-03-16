//
//  SearchResultCell.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 08.03.2023.
//

import SwiftUI

struct SearchViewCell: View {
    @State var isExpanded = false
    let artwork: Artwork
    let width = UIScreen.main.bounds.width
    let columns = [
        GridItem(.flexible(minimum: 50, maximum: 110)),
        GridItem(.flexible(minimum: 100, maximum: 200))
    ]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Image(uiImage: artwork.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: width - 48,
                       maxHeight: artwork.portraitMode ? width : artwork.height)
                .background(.secondary.opacity(0.25))
            
            VStack (alignment: .leading, spacing: 8) {
                VStack {
                    HStack (alignment: .center) {
                        Text("Artwork")
                        Spacer()
                        DownloadButton(artwork: artwork)
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
                            withAnimation {
                                self.isExpanded.toggle()
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal)
                
                if isExpanded {
                    Divider()
                        .padding(.bottom, 8)
                    
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
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .transition(.move(edge: .bottom))
        }
        .frame(width: width - 48)
        .cornerRadius(3)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(.secondary, lineWidth: 0.3)
                .shadow(color: .secondary, radius: 2)
        )
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
