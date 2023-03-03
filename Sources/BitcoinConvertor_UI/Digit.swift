//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-22.
//


import Foundation
enum Digit: Int, CaseIterable, CustomStringConvertible {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    var description: String {
        "\(rawValue)"
    }
}
