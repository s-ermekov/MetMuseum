//
//  SavePhotoButton.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 11.03.2023.
//

import SwiftUI

struct DownloadButton: View {
    @State private var isSaving = false
    @State private var showDialog = false
    @State private var showAlert = false
    
    let artwork: Artwork
    
    init(_ artwork: Artwork) {
        self.artwork = artwork
    }
    
    var body: some View {
        Button {
            self.showDialog = true
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
        .alert("Failure", isPresented: $showAlert, actions: {
            Button("Try again") {
                self.showDialog = true
            }
            Button("Cancel", role: .cancel) {
                self.showAlert = false
                self.isSaving = false
            }
        }, message: {
            Text("Error handled while trying to download an image")
        })
        .confirmationDialog("Download image", isPresented: $showDialog) {
            Button("Small image") {
                self.isSaving = true
                Task {
                    self.showAlert = await artwork.savePhoto(smallImage: true)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isSaving = false
                }
            }
            
            Button("Large image") {
                self.isSaving = true
                Task {
                    self.showAlert = await artwork.savePhoto(smallImage: false)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isSaving = false
                }
            }
            Button("Cancel", role: .cancel) {
                self.isSaving = false
            }
        } message: {
            Text("Select image quality")
        }
    }
}

extension Artwork {
    func savePhoto(smallImage: Bool) async -> Bool {
        // returns true if error handled
        if smallImage {
            // trying to save small preloaded image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        } else {
            // trying to download large image
            do {
                guard let urlString = self.objectData.primaryImage else { throw APIError.nilUrlString }
                guard let url = URL(string: urlString) else { throw APIError.badURL }
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { throw APIError.badImage }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } catch {
                return true
            }
        }
        return false
    }
}
