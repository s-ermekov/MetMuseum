//
//  SavePhotoButton.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 11.03.2023.
//

import SwiftUI

struct DownloadButton: View {
    @State private var isSaving = false
    
    let artwork: Artwork
    
    var body: some View {
        Button {
            self.isSaving = true
            artwork.savePhoto()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isSaving = false
            }
        } label: {
            Text("Download")
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
        Task(priority: .background) {
            do {
                guard let urlString = self.objectData.primaryImage else { throw APIError.nilUrlString }
                guard let url = URL(string: urlString) else { throw APIError.badURL }
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { throw APIError.badImage }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
