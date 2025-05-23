import Foundation
import When

// MARK: - Serialization

public extension Promise where T: Response {
    func toData() -> Promise<Data> {
        return then { response -> Data in
            try DataSerializer().serialize(response: response)
        }
    }

    func toString(_ encoding: String.Encoding? = nil) -> Promise<String> {
        return then { response -> String in
            try StringSerializer(encoding: encoding).serialize(response: response)
        }
    }

    func toJsonArray(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<[[String: Any]]> {
        return then { response -> [[String: Any]] in
            let serializer = JsonSerializer(options: options)

            let data = try serializer.serialize(response: response)

            guard !(data is NSNull) else {
                return []
            }

            guard let array = data as? [[String: Any]] else {
                throw NetworkError.jsonArraySerializationFailed(response: response)
            }

            return array
        }
    }

    func toJsonDictionary(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<[String: Any]> {
        return then { response -> [String: Any] in
            let serializer = JsonSerializer(options: options)

            let data = try serializer.serialize(response: response)

            guard !(data is NSNull) else {
                return [:]
            }

            guard let dictionary = data as? [String: Any] else {
                throw NetworkError.jsonDictionarySerializationFailed(response: response)
            }

            return dictionary
        }
    }
}
