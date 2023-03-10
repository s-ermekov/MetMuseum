//
//  SavePhotoButton.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 11.03.2023.
//

import SwiftUI

struct SavePhotoButton: View {
    @State private var isSaving = false
    
    let artwork: Artwork
    
    init(_ artwork: Artwork) {
        self.artwork = artwork
    }
    
    var body: some View {
        Button {
            isSaving = true
            artwork.savePhoto()
            isSaving = false
        } label: {
            Text("Save")
                .opacity(isSaving ? 0 : 1)
                .overlay {
                    if isSaving {
                        ProgressView()
                    }
                }
        }
        .buttonStyle(.bordered)
        .disabled(isSaving)

    }
}

extension Artwork {
    func savePhoto() {
        Task {
            do {
                guard let urlString = self.objectData.primaryImage else { throw APIError.nilString }
                
                guard let url = URL(string: urlString) else { throw APIError.badURL }
                
                let session = URLSession(configuration: .default)
                
                let (data, _) = try await session.data(from: url)
                
                guard let image = UIImage(data: data) else { throw APIError.badImage }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } catch {
                print(error)
            }
        }
    }
}
