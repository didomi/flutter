//
//  EntitiesHelper.swift
//  didomi_sdk
//
//  Created by Felipe Saez V on 1/06/21.
//

import Foundation
import Didomi

// Class used to do computations related to vendors and purposes.
class EntitiesHelper {
    // Convert an array of purposes into an array of dictionaries.
    static func dictionaries(from purposes: [Purpose]) -> [[String: Any]?] {
        return purposes.map { dictionary(from: $0) }
    }
    
    // Convert an instance of Purpose into a dictionary.
    static func dictionary(from purpose: Purpose?) -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(purpose)
        return dictionary(from: data)
    }
    
    // Convert an array of vendors into an array of dictionaries.
    static func dictionaries(from vendors: [Vendor]) -> [[String: Any]?] {
        return vendors.map { dictionary(from: $0) }
    }
    
    // Convert an instance of Vendor into a dictionary.
    static func dictionary(from vendor: Vendor?) -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(vendor)
        return dictionary(from: data)
    }
    
    // Convert an instance of CurrentUserStatus into a dictionary.
    static func dictionary(from currentUserStatus: CurrentUserStatus?) -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(currentUserStatus)
        var encoded = dictionary(from: data)
        // Regulation of the status object ("custom" for a regulation configuration, the JSON contains the regulation name)
        if let currentUserStatus = currentUserStatus {
            encoded?["regulation"] = currentUserStatus.regulation.description
        }
        // The regulation configuration is not encoded by the SDK
        encoded?["regulation_configuration"] = (dictionary(from: currentUserStatus?.regulationConfiguration) as Any?) ?? NSNull()
        return encoded
    }

    // Convert an instance of Regulation.Configuration into a dictionary (Regulation.Configuration is not Codable).
    static func dictionary(from configuration: Regulation.Configuration?) -> [String: Any]? {
        guard let configuration = configuration else {
            return nil
        }
        return [
            "id": configuration.id,
            "versionId": (configuration.versionId as Any?) ?? NSNull(),
            "numericalId": (configuration.numericalId as Any?) ?? NSNull(),
            "regulationName": configuration.regulationName,
            "tokenStorageName": configuration.tokenStorageName,
            "mixed": configuration.mixed
        ]
    }
    
    // Convert an instance of VendorStatus into a dictionary.
    static func dictionary(from vendorStatus: CurrentUserStatus.VendorStatus?) -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(vendorStatus)
        return dictionary(from: data)
    }

    // Convert an instance of UserStatus into a dictionary.
    static func dictionary(from userStatus: UserStatus?) -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(userStatus)
        return dictionary(from: data)
    }
    
    // Convert an instance of Data into a dictionary.
    static private func dictionary(from data: Data?) -> [String: Any]? {
        if let data = data {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } else {
            return nil
        }
    }
}
