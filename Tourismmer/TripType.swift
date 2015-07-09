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
    case Snowboarding = "SNOWBOARDING"
    case Parachute = "PARAQUEDAS"
    case Shopping = "COMPRAS"
    case HikesWaterfalls = "TRILHAS E CACHOEIRAS"
    case Social = "SOCIAL"
    case Backpacking = "MOCHILÃO"
    
    case Error = ""
    
    func id() -> Int {
        if self.rawValue == Vacation.rawValue {
            return 1
        } else if self.rawValue == Business.rawValue {
            return 2
        } else if self.rawValue == ExchangeProgram.rawValue {
            return 16
        } else if self.rawValue == Excursion.rawValue {
            return 17
        } else if self.rawValue == Snowboarding.rawValue {
            return 18
        } else if self.rawValue == Parachute.rawValue {
            return 19
        } else if self.rawValue == Shopping.rawValue {
            return 20
        } else if self.rawValue == HikesWaterfalls.rawValue {
            return 21
        } else if self.rawValue == Social.rawValue {
            return 22
        } else if self.rawValue == Backpacking.rawValue {
            return 23
        } else {
            return 0
        }
    }
    
    static func valueFromId(id: Int) -> TripType {
        if id == 1 {
            return TripType.Vacation
        } else if id == 2 {
            return TripType.Business
        } else if id == 16 {
            return TripType.ExchangeProgram
        } else if id == 17 {
            return TripType.Excursion
        } else if id == 18 {
            return TripType.Snowboarding
        } else if id == 19 {
            return TripType.Parachute
        } else if id == 20 {
            return TripType.Shopping
        } else if id == 21 {
            return TripType.HikesWaterfalls
        } else if id == 22 {
            return TripType.Social
        } else if id == 23 {
            return TripType.Backpacking
        } else {
            return TripType.Error
        }
    }
}