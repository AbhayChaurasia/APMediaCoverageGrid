//
//  ContentView.swift
//  Assignment_Acharya _Prashant
//
//  Created by Abhay Chaurasia on 11/12/25.
//
import SwiftUI

struct ContentView: View {

    @StateObject private var gridVM = GridViewModel()

    private let minCellWidth: CGFloat = 110
    private let spacing: CGFloat = 8

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    gridView(for: geo.size.width)
                }
            }
            .navigationTitle("Image Grid")
            .onAppear {
                gridVM.fetchCoverages()
            }

            .alert(
                "Error",
                isPresented: .constant(gridVM.errorMessage != nil),
                actions: {
                    Button("OK") {
                        gridVM.errorMessage = nil
                    }
                },
                message: {
                    Text(gridVM.errorMessage ?? "")
                }
            )
        }
    }

    // MARK: - Grid View

    @ViewBuilder
    private func gridView(for width: CGFloat) -> some View {
        let columns = computeColumns(for: width)

        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(gridVM.items) { item in
                GridCell(item: item, width: width, columns: columns.count)
            }
        }
        .padding(spacing)
    }

    // MARK: - Helpers

    private func computeColumns(for totalWidth: CGFloat) -> [GridItem] {
        let available = totalWidth - spacing * 2
        let count = max(Int(available / (minCellWidth + spacing)), 1)
        return Array(
            repeating: GridItem(.flexible(), spacing: spacing),
            count: count
        )
    }

    private func cellHeight(for totalWidth: CGFloat, columns: Int) -> CGFloat {
        let totalSpacing = CGFloat(columns - 1) * spacing + (spacing * 2)
        return (totalWidth - totalSpacing) / CGFloat(columns)
    }
}
