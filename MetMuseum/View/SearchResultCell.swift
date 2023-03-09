//
//  SearchResultCell.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 08.03.2023.
//

import SwiftUI

struct SearchResultCell: View {
    let thumbnail: Thumbnail?
    
    var body: some View {
        VStack {
            if let thumbnail = thumbnail {
                ZStack {
                    Image(uiImage: thumbnail.image)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                    
//                    Text("\(thumbnail.id)")
                }
                .frame(minWidth: 150, maxWidth: 300, minHeight: 200, maxHeight: 250)
                .background(.gray)
            } else {
                ProgressView()
                    .frame(minWidth: 150, maxWidth: 300, minHeight: 200, maxHeight: 250)
            }
        }
    }
}

struct SearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
//        SearchResultCell(image: UIImage(systemName: "person.fill")!)
        SearchResultCell(thumbnail: Thumbnail(id: 1, image: UIImage(systemName: "person.fill")!))
    }
}
