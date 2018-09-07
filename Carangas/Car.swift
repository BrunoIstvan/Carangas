//
//  Car.swift
//  Carangas
//
//  Created by Usuário Convidado on 18/08/2018.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    
    var _id: String?
    var name: String = ""
    var price: Double = 0
    var brand: String = ""
    var gasType: Int = 0

    var gas: String {

        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }

    }
    
}
