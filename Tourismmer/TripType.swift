//
//  TripType.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 8/5/14.
//  Copyright (c) 2014 Felipe Lopes. All rights reserved.
//

import Foundation

enum TripType : String {
    case Vacation = "FÉRIAS"
    case Business = "NEGÓCIOS"
    case ExchangeProgram = "INTERCÂMBIO"
    case Excursion = "EXCURSÃO"
    case Error = ""
    
    func id() -> Int {
        if self.rawValue == "FÉRIAS" {
            return 1
        } else if self.rawValue == "NEGÓCIOS" {
            return 2
        } else if self.rawValue == "INTERCÂMBIO" {
            return 3
        } else if self.rawValue == "EXCURSÃO" {
            return 4
        } else {
            return 0
        }
    }
    
    static func valueFromId(id: Int) -> TripType {
        if id == 1 {
            return TripType.Vacation
        } else if id == 2 {
            return TripType.Business
        } else if id == 3 {
            return TripType.ExchangeProgram
        } else if id == 4 {
            return TripType.Excursion
        } else {
            return TripType.Error
        }
    }
}