// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

public typealias BodyEncoder = () throws -> Data
public typealias FileParameter = (String, File)
public typealias Files = [FileParameter]
public typealias Headers = Set<HTTPHeader>
public typealias ParameterEncoder = (Parameters) throws -> Data
public typealias Parameters = [String: Any]

/// A wrapper type for uploading a file.
public struct File {
    public let data: Data
    public let fileData: Parameters?
    public let filename: String
    public let mimetype: String?
}
