// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

/// Type representing HTTP methods.
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public struct HTTPMethod: Hashable {
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String
}

/// A wrapper type for a set of common HTTP headers.
public struct HTTPHeader: Hashable {
    public static func accept(_ value: String) -> HTTPHeader { HTTPHeader(key: "Accept", value: value) }
    public static func cacheControl(_ value: String) -> HTTPHeader { HTTPHeader(key: "Cache-Control", value: value) }
    public static func contentLength(_ value: String) -> HTTPHeader { HTTPHeader(key: "Content-Length", value: value) }
    public static func contentType(_ value: String) -> HTTPHeader { HTTPHeader(key: "Content-Type", value: value) }
    public static func userAgent(_ value: String) -> HTTPHeader { HTTPHeader(key: "User-Agent", value: value) }

    public let key: String
    public let value: String
}

/// Represent the encoding of parameters in an `URLRequest`.
public struct ParameterEncoding: Hashable {
    public static let json = ParameterEncoding(rawValue: "application/json")
    public static let url = ParameterEncoding(rawValue: "application/x-www-form-urlencoded")

    public let rawValue: String
}
