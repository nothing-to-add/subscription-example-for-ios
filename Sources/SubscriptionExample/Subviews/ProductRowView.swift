// ProductRowView.swift
// View for displaying product options

import SwiftUI

public struct ProductRowView: View {
    public let name: String
    public let description: String
    public let price: String
    public let periodText: String?
    public let isSelected: Bool
    public let monthlyPrice: String?
    
    public init(name: String, description: String, price: String, periodText: String?, isSelected: Bool, monthlyPrice: String?) {
        self.name = name
        self.description = description
        self.price = price
        self.periodText = periodText
        self.isSelected = isSelected
        self.monthlyPrice = monthlyPrice
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            // Product name in center
            Text(name)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
            
            // Price
            Text(price)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
            
            // Monthly price calculation if available
            if let monthlyPrice = monthlyPrice {
                Text(monthlyPrice)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
            }
        }
        .frame(maxHeight: 90)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? 
                      LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom) : 
                        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 4 : 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .padding(.horizontal, 8)
    }
}

#Preview {
    VStack {
        ProductRowView(name: "Monthly Premium",
                     description: "Unlimited access to all premium features with monthly billing",
                     price: "$9.99",
                     periodText: "Monthly",
                     isSelected: false,
                     monthlyPrice: nil)
        
        ProductRowView(name: "Annual Premium",
                     description: "Unlimited access to all premium features with annual billing",
                     price: "$79.99",
                     periodText: "Annual (Save 20%)",
                     isSelected: true,
                     monthlyPrice: "$6.67 / month")
    }
    .padding()
    .background(Color.white)
}
