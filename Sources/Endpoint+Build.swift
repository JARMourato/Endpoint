// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

extension Endpoint {
    
    public mutating func withBody(encoder: @escaping BodyEncoder) -> Endpoint {
        self.bodyEncoder = encoder
        return self
    }
}
