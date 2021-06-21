// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

extension Endpoint {
    
    public func withBody(encoder: @escaping BodyEncoder) -> Endpoint {
        var new = self
        new.bodyEncoder = encoder
        return new
    }
}
