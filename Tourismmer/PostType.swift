//
//  PostType.swift
//  Tourismmer
//
//  Created by Felipe Lopes on 1/24/15.
//  Copyright (c) 2015 Felipe Lopes. All rights reserved.
//

import Foundation

enum PostType : String {
    case Question = "DÚVIDA"
    case Recomendation = "RECOMENDAÇÃO"
    case Error = ""
    
    func id() -> Int {
        if self.rawValue == "DÚVIDA" {
            return 1
        } else if self.rawValue == "RECOMENDAÇÃO" {
            return 2
        } else if self.rawValue == "" {
            return 3
        } else if self.rawValue == "" {
            return 4
        } else {
            return 0
        }
    }
    
    static func valueFromId(id: Int) -> PostType {
        if id == 1 {
            return PostType.Question
        } else if id == 2 {
            return PostType.Recomendation
        } else if id == 3 {
            return PostType.Error
        } else if id == 4 {
            return PostType.Error
        } else {
            return PostType.Error
        }
    }
}