//
//  Decryptor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 04.01.23.
//

import Foundation

final class Decryptor {
    
    func getString(from bytes: [UInt8]) -> String {
        String(bytes: bytes, encoding: .utf8) ?? ""
    }
}
