// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

extension Endpoint {
    
    /// Create an endpoint with the path and the HTTPMethod.
    /// - Parameters:
    ///   - method: the desired HTTPMethod.
    ///   - path: the path to be appended to a base URL when building the URLRequest.
    public init(method: HTTPMethod, path: String) {
        self.init(method: method.rawValue, path: path)
    }
    
    
    /// Add a custom body build closure to the `Endpoint`.
    /// - Parameter encoder: A custom body encoder used to create the body of the `Endpoint` request.
    /// - Returns: Returns a copy of self with a custom body encoder.
    public func withBody(encoder: @escaping BodyEncoder) -> Endpoint {
        var new = self
        new.bodyEncoder = encoder
        return new
    }
    
    /// Add headers to the `Endpoint`
    /// - Parameter headers: The headers to be added to the request, when this `Endpoint` is called.
    /// - Returns: Returns a copy of self with the added headers
    public func withHeaders(_ headers: [String:String]) -> Endpoint {
        var new = self
        new.headers = Set(headers.map(HTTPHeader.init))
        return new
    }
    
    /// Add parameters to the `Endpoint`
    /// - Parameter parameters: The parameters to be added to the request, when this `Endpoint` is called.
    /// - Returns: Returns a copy of self with the added parameters
    public func withParameters(_ parameters: Parameters) -> Endpoint {
        var new = self
        new.parameters.merge(parameters, uniquingKeysWith: { $1 })
        return new
    }
}
