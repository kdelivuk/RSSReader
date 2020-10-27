//
//  GeneralError.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import Foundation

enum ErrorType {
    case api
    case parsing
    case wrongUrlFormat
}

struct GeneralError: Error {
    let type: ErrorType
    let description: String
}
