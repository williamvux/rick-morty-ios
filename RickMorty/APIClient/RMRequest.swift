//
//  RMRequest.swift
//  RickMorty
//
//  Created by William Vux on 31/12/2023.
//

import Foundation

/// Object that represents a single API call
final class RMRequest {
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endpoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if (!pathComponents.isEmpty) {
            string += "/"
            pathComponents.forEach { path in
                string += "/\(path)"
            }
        }
        if (!queryParameters.isEmpty) {
            string += "?"
            let argString = queryParameters.compactMap { item in
                guard let value = item.value else { return nil }
                return "\(item.name)=\(value)"
            }.joined(separator: "&")
            
            string += argString
        }
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointStr = components[0]
                if let rmEndpoint = (RMEndpoint(rawValue: endpointStr)) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointStr = components[0]
                let queryItemsStr = components[1]
                let queryItems: [URLQueryItem] = queryItemsStr.components(separatedBy: "&").compactMap ({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let paths = $0.components(separatedBy: "=")
                    return URLQueryItem(name: paths[0], value: paths[1])
                })
                if let rmEndpoint = (RMEndpoint(rawValue: endpointStr)) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharacters = RMRequest(endpoint: .character)
}
