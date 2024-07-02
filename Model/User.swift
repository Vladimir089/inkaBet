//
//  User.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import Foundation


struct User: Codable {
    var name: String
    var weight: Int
    var height: Int
    var norm: Int
    var age: Int
    var image: Data
    
    init(name: String, weight: Int, height: Int, norm: Int, image: Data, age: Int) {
        self.name = name
        self.weight = weight
        self.height = height
        self.norm = norm
        self.image = image
        self.age = age
    }
}
