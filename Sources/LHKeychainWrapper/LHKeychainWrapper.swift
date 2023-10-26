import Foundation

public final class LHKeychainWrapper: LHKeychainWrapperProtocol {
    public init() {}
    
    public func setString(_ value: String, forkey key: String) {
        if let data = value.data(using: .utf8) {
            set(data, forKey: key)
        }
    }

    public func setBool(_ value: Bool, forkey key: String) {
        setObject(value, forKey: key)
    }

    public func setInt(_ value: Int, forkey key: String) {
        setObject(value, forKey: key)
    }

    public func setObject(_ value: Codable, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: key)
        }
    }

    public func appendObject<T: Codable>(_ value: T, forKey key: String) {
        var collection: [T]? = object(for: key)
        if collection == nil {
            collection = [value]
        } else {
            collection?.append(value)
        }
        if let data = try? JSONEncoder().encode(collection) {
            set(data, forKey: key)
        }
    }

    public func delete(_ key: String) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        if SecItemDelete(attributes as CFDictionary) == noErr {
            print("User removed successfully from the keychain")
        } else {
            print("User does not exist")
        }
    }

    public func string(forkey key: String) -> String? {
        guard let data = object(forkey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public func bool(forkey key: String) -> Bool {
        let value: Bool? = object(for: key)
        return value ?? false
    }

    public func int(forkey key: String) -> Int? {
        let value: Int? = object(for: key)
        return value
    }

    public func object<T: Codable>(for key: String) -> T? {
        guard let data = object(forkey: key) else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func set(_ data: Data, forKey key: String) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]

        delete(key)

        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
    }

    private func object(forkey key: String) -> Data? {
        var item: CFTypeRef?
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data {
                return data
            }
        } else {
            print("Something went wrong trying to find the user in the keychain")
        }

        return nil
    }
}
