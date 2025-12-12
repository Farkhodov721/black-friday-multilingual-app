//
//  ContenView
//  BlackFridayApp
//
//  Created by Farkhodov Abdulaziz on 11/12/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @State private var selectedProduct: Product? = nil
    
    private var currentLocale: Locale {
        switch selectedLanguage {
        case "es": return Locale(identifier: "es_ES")
        case "ar": return Locale(identifier: "ar_SA")
        default: return Locale(identifier: "en_US")
        }
    }
    
    private var isRTL: Bool { selectedLanguage == "ar" }
    
    private var currentFlag: String {
        switch selectedLanguage {
        case "en": return "🇺🇸"
        case "es": return "🇪🇸"
        case "ar": return "🇸🇦"
        default: return "🌐"
        }
    }
    
    private var languageButtonText: String {
        switch selectedLanguage {
        case "es": return "Español"
        case "ar": return "العربية"
        default: return "English"
        }
    }
    
    private var languageMenuButton: some View {
        Menu {
            Button { selectedLanguage = "en" } label: { Text("English 🇺🇸") }
            Button { selectedLanguage = "es" } label: { Text("Español 🇪🇸") }
            Button { selectedLanguage = "ar" } label: { Text("العربية 🇸🇦") }
        } label: {
            Text(currentFlag)
                .font(.title2)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
        }
    }
    
    private func currencyFormatter(for price: Double) -> String {
        let converted = Int(
            selectedLanguage == "es" ? price * 0.86 :
            selectedLanguage == "ar" ? price * 3.75 : price
        )
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        formatter.locale = Locale(identifier: selectedLanguage == "ar" ? "en_US" : currentLocale.identifier)
        
        return formatter.string(from: NSNumber(value: converted)) ?? "\(converted)"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators:false){
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(sampleProducts) { product in
                        ProductCard(product: product, language: selectedLanguage, currencyFormatter: currencyFormatter)
                            .onTapGesture {
                                selectedProduct = product
                            }
                    }
                }
                .padding()
            }
            .ignoresSafeArea(edges: .bottom)
            .background(
                NavigationLink(
                    destination: selectedProduct.map { ProductDetailView(product: $0) },
                    isActive: Binding(
                        get: { selectedProduct != nil },
                        set: { if !$0 { selectedProduct = nil } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            )
            .navigationTitle("SALE")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .toolbar {
                ToolbarItem(placement: isRTL ? .navigationBarLeading : .navigationBarTrailing) {
                    HStack(spacing: 1) {
                        if isRTL {
                            languageMenuButton
                            Image(systemName: "cart")
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.secondary)
                                .rotationEffect(isRTL ? .degrees(180) : .degrees(0))
                                .offset(x: 250)
                        } else {
                            Image(systemName: "cart")
                                .foregroundColor(.secondary)
                                .scaleEffect(x: isRTL ? -1 : 1, anchor: .center)
                            languageMenuButton
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.secondary)
                                .rotationEffect(isRTL ? .degrees(180) : .degrees(0))
                                .offset(x: -330)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Product Card (Uniform Size)
struct ProductCard: View {
    let product: Product
    let language: String
    let currencyFormatter: (Double) -> String
    
    private var productName: String {
        product.names[language] ?? product.names["en"] ?? "Product"
    }
    private var isRTL: Bool { language == "ar" }
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 230)
                    .cornerRadius(14)
                    .overlay(
                        Image(product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                    )
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray4), lineWidth: 1))
                
                VStack {
                    HStack {
                        if isRTL {
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(12)
                                .offset(x:110)
                            Spacer()
                        } else {
                            Spacer()
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(12)
                        }
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        if isRTL { Spacer() }
                        Text("-\(product.discountPercent)%")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical,6)
                            .background(Color.red)
                            .foregroundColor(.white)
                        if !isRTL { Spacer() }
                    }
                    .padding(1)
                }
            }
            .frame(height: 220)
            
            VStack(alignment: isRTL ? .trailing : .leading, spacing: 6) {
                Text(productName)
                    .font(.headline).bold()
                    .lineLimit(2)
                    .multilineTextAlignment(isRTL ? .trailing : .leading)
                HStack {
                    if isRTL {
                        Text(currencyFormatter(product.oldPriceUSD)).strikethrough().foregroundColor(.secondary)
                        Text(currencyFormatter(product.newPriceUSD)).font(.title2).bold().foregroundStyle(.red)
                    } else {
                        Text(currencyFormatter(product.newPriceUSD)).font(.headline).bold().foregroundStyle(.red)
                        Text(currencyFormatter(product.oldPriceUSD)).strikethrough().foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

// MARK: - Product Detail View
struct ProductDetailView: View {
    let product: Product
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    private var currentLocale: Locale {
        switch selectedLanguage {
        case "es": return Locale(identifier: "es_ES")
        case "ar": return Locale(identifier: "ar_SA")
        default: return Locale(identifier: "en_US")
        }
    }
    
    private func price(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = currentLocale
        let converted = selectedLanguage == "es" ? amount * 0.86 :
                        selectedLanguage == "ar" ? amount * 3.75 : amount
        return formatter.string(from: NSNumber(value: converted)) ?? "\(amount)"
    }
    
    var body: some View {
        ScrollView(showsIndicators:false){
            VStack(spacing: 24) {
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 360)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                VStack(alignment: selectedLanguage == "ar" ? .trailing : .leading, spacing: 16) {
                    Text(product.names[selectedLanguage] ?? product.names["en"] ?? "Product")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(selectedLanguage == "ar" ? .trailing : .leading)
                    
                    HStack(spacing: 12) {
                        if selectedLanguage == "ar" {
                            Text(price(product.oldPriceUSD))
                                .font(.title2)
                                .strikethrough()
                                .foregroundColor(.secondary)
                            Text(price(product.newPriceUSD))
                                .font(.system(size: 40))
                                .bold().foregroundStyle(.red)
                        } else {
                            Text(price(product.newPriceUSD))
                                .font(.system(size: 40))
                                .bold().foregroundStyle(.red)
                            Text(price(product.oldPriceUSD))
                                .font(.title2)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }
                    }

                    Picker("Language", selection: $selectedLanguage) {
                        Text("🇺🇸").tag("en")
                        Text("🇪🇸").tag("es")
                        Text("🇸🇦").tag("ar")
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .frame(maxWidth: 240)
                }
                .padding()
            }
        }
        .navigationTitle("SALE")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.layoutDirection, selectedLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    ContentView()
}
