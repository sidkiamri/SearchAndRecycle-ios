//
//  utility.swift
//  Reducetrash
//
//  Created by taha majdoub on 7/4/2023.
//

import Foundation


class Constant {
    private static var _wasteType: WasteType?
    
    static var wasteType: WasteType {
        get {
            if _wasteType == nil {
                let fileUrl = Bundle.main.url(forResource: "waste_type_starter", withExtension: "json")
                let data = try! Data(contentsOf: fileUrl!)
                _wasteType = try! JSONDecoder().decode(WasteType.self, from: data)
            }
            return _wasteType!
        }
        set {
            _wasteType = newValue
        }
    }
}
