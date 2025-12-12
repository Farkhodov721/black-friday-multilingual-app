//
//  Product.swift
//  BlackFridayApp
//
//  Created by Farkhodov Abdulaziz on 11/12/25.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()
    let names: [String: String]
    let oldPriceUSD: Double
    let newPriceUSD: Double
    let discountPercent: Int
    let imageName: String
}

let sampleProducts: [Product] = [
    Product(
        names: ["en": "Apple Watch SE", "es": "Apple Watch SE", "ar": "ساعة أبل SE"],
        oldPriceUSD: 249.00,
        newPriceUSD: 159.00,
        discountPercent: 36,
        imageName: "apple-watch-se"
    ),
    Product(
        names: ["en": "Apple AirPods 4", "es": "Apple AirPods 4", "ar": "سماعات أبل إير بودز 4"],
        oldPriceUSD: 129.00,
        newPriceUSD: 85.00,
        discountPercent: 34,
        imageName: "airpods-4"
    ),
    Product(
        names: ["en": "Apple MacBook Air 13-inch", "es": "Apple MacBook Air de 13 pulgadas", "ar": "ماك بوك إير 13 إنش من أبل"],
        oldPriceUSD: 999.00,
        newPriceUSD: 749.00,
        discountPercent: 25,
        imageName: "macbook-air"
    ),
    Product(
        names: ["en": "Hoka Bondi 8 Sneakers", "es": "Zapatillas Hoka Bondi 8", "ar": "أحذية هوكا بوندي 8"],
        oldPriceUSD: 165.00,
        newPriceUSD: 132.00,
        discountPercent: 20,
        imageName: "hoka-sneakers"
    ),
    Product(
        names: ["en": "Levi's 501 Jeans", "es": "Vaqueros Levi's 501", "ar": "جينز ليفايز 501"],
        oldPriceUSD: 80.00,
        newPriceUSD: 48.00,
        discountPercent: 40,
        imageName: "levis-jeans"
    ),
    Product(
        names: ["en": "Samsung TV", "es": "Televisor Samsung 4K de 55 pulgadas", "ar": "تلفزيون سامسونج 4K حجم 55 إنش"],
        oldPriceUSD: 500.00,
        newPriceUSD: 350.00,
        discountPercent: 30,
        imageName: "samsung-tv"
    )
]
