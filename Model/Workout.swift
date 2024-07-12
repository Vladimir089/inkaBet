//
//  Workout.swift
//  inkaBet
//
//  Created by Владимир Кацап on 04.07.2024.
//

import Foundation


struct Workout: Codable {
    var name: String
    var time: String
    var approaches: Int
    var repetitions: Int
    var calories: CGFloat
    var dete: Date
    
    init(name: String, time: String, approaches: Int, repetitions: Int, calories: CGFloat, dete: Date) {
        self.name = name
        self.time = time
        self.approaches = approaches
        self.repetitions = repetitions
        self.calories = calories
        self.dete = dete
    }
}




struct Plan: Codable {
    var image: Data
    var name: String
    var execurse: [Execurse]
    
    init(image: Data, name: String, execurse: [Execurse]) {
        self.image = image
        self.name = name
        self.execurse = execurse
    }
}


struct Execurse: Codable {
    var image: Data
    var name: String
    var explanation: String
    
    init(image: Data, name: String, explanation: String) {
        self.image = image
        self.name = name
        self.explanation = explanation
    }
}
