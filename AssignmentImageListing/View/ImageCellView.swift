//
//  ImageCellView.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//


import SwiftUI

struct ImageCellView: View {
    @StateObject private var vm: ImageCellViewModel
    private let placeholder = Image(systemName: "photo")
    
    init(url: URL) {
        _vm = StateObject(wrappedValue: ImageCellViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if let ui = vm.image {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else if vm.isLoading {
                ProgressView()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .padding(16)
                    .opacity(0.4)
            }
        }
        .background(Color(white: 0.95))
        .cornerRadius(8)
        .onAppear {
            vm.load()
        }
        .onDisappear {
            vm.cancel()
        }
    }
}
