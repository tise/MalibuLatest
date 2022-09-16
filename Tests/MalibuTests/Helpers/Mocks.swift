import Foundation
@testable import Malibu
import When

// MARK: - Service

enum TestService: RequestConvertible {
    case fetchPosts
    case showPost(id: Int)
    case createPost(title: String)
    case replacePost(id: Int, title: String)
    case updatePost(id: Int, title: String)
    case deletePost(id: Int)
    case head

    static var baseUrl: URLStringConvertible? = "http://api.loc"
    static var headers: [String: String] = [:]

    var request: Request {
        switch self {
        case .fetchPosts:
            return Request.get("posts")
        case let .showPost(id):
            return Request.get("posts/\(id)")
        case let .createPost(title):
            return Request.post("posts", parameters: ["title": title])
        case let .replacePost(id, title):
            return Request.put("posts/\(id)", parameters: ["title": title])
        case let .updatePost(id, title):
            return Request.patch("posts/\(id)", parameters: ["title": title])
        case let .deletePost(id):
            return Request.delete("posts/\(id)")
        case .head:
            return Request.head("posts")
        }
    }
}
