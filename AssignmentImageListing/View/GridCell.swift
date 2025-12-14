//
//  GridCell.swift
//  AssignmentImageListing
//
//  Created by Abhay Chaurasia on 14/12/25.
//


import SwiftUI

struct GridCell: View {

    let item: CoverageItem
    let width: CGFloat
    let columns: Int

    private let spacing: CGFloat = 8

    var body: some View {
        if let url = item.thumbnail.imageURL() {
            ImageCellView(url: url)
                .frame(height: cellHeight)
        } else {
            Color.gray
                .frame(height: cellHeight)
        }
    }

    private var cellHeight: CGFloat {
        let totalSpacing = CGFloat(columns - 1) * spacing + (spacing * 2)
        return (width - totalSpacing) / CGFloat(columns)
    }
}
