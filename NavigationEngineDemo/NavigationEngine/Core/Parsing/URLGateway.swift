//
//  URLGateway.swift
//  Just Eat
//
//  Created by Alberto De Bortoli on 27/04/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

class URLGateway {
    
    static let domain = "com.justeat.URLGateway"
    
    enum ErrorCode: Int {
        case missingURLScheme
        case unsupportedUniversalLink
        case generic
    }

    private let universalLinkConverter: UniversalLinkConverter
    private let settings: DeepLinkingSettingsProtocol
    
    init(settings: DeepLinkingSettingsProtocol) {
        self.settings = settings
        self.universalLinkConverter = UniversalLinkConverter(settings: settings)
    }
    
    func handleURL(_ url: URL) -> Future<DeepLink> {
        let promise = Promise<DeepLink>()
        
        guard let scheme = url.scheme?.lowercased() else {
            let error = NSError(domain: URLGateway.domain, code: ErrorCode.missingURLScheme.rawValue, userInfo: nil)
            promise.setError(error)
            return promise.future
        }
        
        // 1. check if universal link
        if settings.universalLinkSchemes.contains(scheme) {
            self.resultForUniversalLink(url).finally { future in
                promise.setResolution(of: future)
            }
        }
            
        // 2. check if deep link
        else if settings.internalDeepLinkSchemes.contains(scheme) {
            promise.setResult(url)
        }
        
        // 3. generic error
        else {
            let genericError = NSError(domain: URLGateway.domain, code: ErrorCode.generic.rawValue, userInfo: nil)
            promise.setError(genericError)
        }
        
        return promise.future
    }
    
    private func resultForUniversalLink(_ url: UniversalLink) -> Future<DeepLink> {
        let promise = Promise<DeepLink>()
        if let deepLink = universalLinkConverter.deepLink(forUniversalLink: url) {
            promise.setResult(deepLink)
        }
        else {
            let genericError = NSError(domain: URLGateway.domain, code: ErrorCode.unsupportedUniversalLink.rawValue, userInfo: nil)
            promise.setError(genericError)
        }
        return promise.future
    }
}

extension URL {
    
    func contains(subparts: [String]) -> Bool {
        return subparts.filter { absoluteString.contains($0) }.count > 0
    }
    
    var allQueryItems: [NSURLQueryItem] {
        let components = NSURLComponents(url: self as URL, resolvingAgainstBaseURL: false)!
        guard let allQueryItems = components.queryItems
            else { return [] }
        return allQueryItems as [NSURLQueryItem]
    }
    
    func queryItemValueFor(key: String) -> String? {
        let predicate = NSPredicate(format: "name=%@", key)
        let queryItem = (allQueryItems as NSArray).filtered(using: predicate).first as? NSURLQueryItem
        return queryItem?.value
    }
}
