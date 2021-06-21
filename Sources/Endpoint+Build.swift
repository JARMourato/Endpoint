// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

extension Endpoint {
    
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
}
