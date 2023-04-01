//
//  MainView.swift
//  MetMuseum
//
//  Created by Санжар Эрмеков on 16.03.2023.
//

import SwiftUI

struct InfoView: View {
    @State private var openGithub: Bool = false
    @State private var openMail: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("A simple application for searching and downloading images of \(Attribute("Open Access").semibold) artworks from \(Attribute("https://metmuseum.org").link). Easy search artworks by keywords.")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 36)
                    
                    Text("Artwork")
                    Image("sunflowersSmall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                    Text("Sunflowers by Vincent van Gogh, 1887")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .italic()
                        .padding(.bottom)
                    
                    Text("Artwork without public image")
                    Image("defaultArtworkImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                        .background(.secondary)
                    Text("Placeholder image")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .italic()
                        .padding(.bottom)
                    
                    HStack {
                        Button("Public repository") {
                            self.openGithub = true
                        }
                        .confirmationDialog("Public repository", isPresented: $openGithub) {
                            Link(destination: URL(string: "https://github.com/s-ermekov/MetMuseum")!) {
                                Label("Open repository", systemImage: "externaldrive.connected.to.line.below")
                            }
                        } message: {
                            Text("Code sources are available on public repository on Github.")
                        }
                        
                        
                        Divider().padding(.horizontal)
                        
                        Button("Contact me") {
                            self.openMail = true
                        }
                        .confirmationDialog("Contact me", isPresented: $openMail) {
                            Link(destination: URL(string: "mailto:sangeek@outlook.com")!) {
                                Label("Open mail application", systemImage: "text.bubble")
                            }
                        } message: {
                            Text("Any suggestions or questions? Please text me.")
                        }
                        
                        
                    }
                }
                .padding(.horizontal, 24)
                .navigationTitle("The Met Museum")
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 2)
                    .clipped()
                    .opacity(0.05)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(APIManager())
    }
}
