// Copyright © 2021 João Mourato. All rights reserved.

import Foundation

/// A representation of an API endpoint
public struct Endpoint {
    /// An entry point to encode a custom body. If set, it will take precedence.
    public var bodyEncoder: BodyEncoder?
    /// An entry point to add custom parameter encoding. If set, it will take precedence.
    public var parameterEncoder: ParameterEncoder?
    /// An array of files to upload.
    public var files: Files = []
    /// The headers to send in the request.
    public var headers: Headers = []
    /// The HTTPMethod to use in the request.
    public let method: String
    /// The boundary to use in a multipart request.
    public var multipartBoundary: String = "3n6P01Nt"
    /// The path of the endpoint we want to reach.
    public let path: String
    /// How the parameters sent in the request should be encoded.
    public var parameterEncoding: ParameterEncoding = .json
    /// The parameters to send in the request.
    public var parameters: Parameters = [:]
    /// The amount of time after which a request made to this endpoint should fail, if no response is received.
    public var timeoutInterval: TimeInterval = 60
    
    public init(method: String, path: String) {
        self.method = method
        self.path = path
    }
}

extension Endpoint {
    
    public func buildURLRequest(with baseURL: URL) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = buildHeaders()
        /*
         Get requests can technically have body's. However, by design, for GET requests
         query parameters will be used, othwerwise a body will be created
         */
        if method == HTTPMethod.get.rawValue {
            urlRequest.url = buildURLWithQueryParameters(for: url)
        } else {
            urlRequest.httpBody = try buildHTTPBody()
        }
        return urlRequest
    }
}

// MARK: - Build Headers
extension Endpoint {
    
    // MARK: Request Headers
    func buildHeaders() -> [String:String] {
        // The default request headers
        let contentTypeValue: String? = {
            if !files.isEmpty {
                return "multipart/form-data; boundary=\(multipartBoundary)"
            } else if !parameters.isEmpty {
                return parameterEncoding.rawValue
            } else {
                return nil
            }
        }()
        // Infered headers for a request - simple syntatic sugar, as these can be overriden by configuration in the assignment that follows
        let httpHeaders: Headers = contentTypeValue != nil ? [ .contentType(contentTypeValue!) ] : []
        // Build headers
        return httpHeaders.toDictionary()
            .merging(headers.toDictionary()) { $1 }
    }
}


// MARK: - Body
extension Endpoint {
    
    // MARK: Query Parameters
    func buildURLWithQueryParameters(for requestURL: URL) -> URL {
        guard !parameters.isEmpty else { return requestURL }
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components.url!
    }
    
    // MARK: HTTPBody
    func buildHTTPBody() throws -> Data? {
        if let bodyEncoder = bodyEncoder { return try bodyEncoder() }
        
        guard files.isEmpty else { return buildMultipartBody() }
        
        if let customEncoding = parameterEncoder { return try? customEncoding(parameters) }
        
        switch parameterEncoding {
        case .json: return try? JSONSerialization.data(withJSONObject: parameters, options: [ .prettyPrinted, .sortedKeys ])
        case .url: return parameters.map { "\($0)=\("\($1)".percentEscaped)" }.joined(separator: "&").data(using: .utf8, allowLossyConversion: true)
        default: return nil
        }
    }
    
    // MARK: Multipart Body
    func buildMultipartBody() -> Data? {
        guard !parameters.isEmpty, !files.isEmpty  else { return nil }
        
        var body = Data()
        let boundary = "--\(multipartBoundary)\r\n".data(using: .utf8)!
        
        func appendFormData(with parameters: Parameters) {
            for (key, value) in parameters {
                let valueToSend: Any = value is NSNull ? "null" : value
                body.append(boundary)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(valueToSend)\r\n".data(using: .utf8)!)
            }
        }
        
        appendFormData(with: parameters)
        
        for (key, value) in files {
            body.append(boundary)
            let partContent: Data = value.data
            let partFilename: String = value.filename
            let partMimetype: String? = value.mimetype
            let dispose = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(partFilename)\"\r\n"
            body.append(dispose.data(using: .utf8)!)
            if let type = partMimetype {
                body.append("Content-Type: \(type)\r\n\r\n".data(using: .utf8)!)
            } else {
                body.append("\r\n".data(using: .utf8)!)
            }
            body.append(partContent)
            body.append("\r\n".data(using: .utf8)!)
            
            if let fileData = value.fileData, !fileData.isEmpty {
                appendFormData(with: fileData)
            }
        }
        
        if body.count > 0 { body.append("--\(multipartBoundary)--\r\n".data(using: .utf8)!) }
        
        return body
    }
}

// MARK: - Utilities
extension Set : ExpressibleByDictionaryLiteral where Element == HTTPHeader {
    func toDictionary() -> [String:String] {
        return reduce(into: [:]) { (result: inout [String:String], header: HTTPHeader) in result[header.key] = header.value }
    }
    
    // MARK: ExpressibleByDictionaryLiteral conformance
    public typealias Key = String
    public typealias Value = String
    public init(dictionaryLiteral elements: (Set.Key, Set.Value)...) { self = Set(elements.map(HTTPHeader.init)) }
}

extension String {
    /// Compliant with RFC 3986 section 2.3 and 3.4
    /// More info here https://www.ietf.org/rfc/rfc3986.txt
    var percentEscaped: String {
        var characterSet: CharacterSet = .alphanumerics
        characterSet.insert(charactersIn: "-._~/?")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)!
    }
}
