//
//  LHKeychainWrapperProtocol.swift
//  
//
//  Created by Luiz Diniz Hammerli on 18/10/23.
//

import Foundation

public protocol LHKeychainWrapperProtocol {
    func setString(_ value: String, forkey key: String)
    func setBool(_ value: Bool, forkey key: String)
    func setInt(_ value: Int, forkey key: String)
    func setObject(_ value: Codable, forKey key: String)
    func delete(_ key: String)
    func string(forkey key: String) -> String?
    func appendObject<T: Codable>(_ value: T, forKey key: String)
    func object<T: Codable>(for key: String) -> T?
}
