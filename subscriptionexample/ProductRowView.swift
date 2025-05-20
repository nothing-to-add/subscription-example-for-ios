//
//  File name: ProductRowView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 21/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct ProductRowView: View {
    let name: String
    let description: String
    let price: String
    let periodText: String?
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.subheadline)
                    .bold()
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if let period = periodText {
                    Text(period)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text(price)
                .font(.headline)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        )
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    ProductRowView(name: "Monthly Premium",
                   description: "Unlimited access to all premium features with monthly billing",
                   price: "$9.99",
                   periodText: "Monthly",
                   isSelected: false)
}
