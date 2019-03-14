//
//  DeepLinkingFacade.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation
import UIKit
import Promis

public class DeepLinkingFacade {
        
    static let domain = "com.justeat.deepLinkingFacade"
    
    enum ErrorCode: Int {
        case couldNotHandleURL
        case couldNotHandleDeepLink
        case couldNotDeepLinkFromShortcutItem
        case couldNotDeepLinkFromSpotlightItem
    }
    
    private let flowControllerProvider: FlowControllerProvider
    private let navigationIntentHandler: NavigationIntentHandler
    private let urlGateway: URLGateway
    private let settings: DeepLinkingSettingsProtocol
    private let userStatusProvider: UserStatusProviding
    
    public init(flowControllerProvider: FlowControllerProvider,
                navigationTransitionerDataSource: NavigationTransitionerDataSource,
                settings: DeepLinkingSettingsProtocol,
                userStatusProvider: UserStatusProviding) {
        self.flowControllerProvider = flowControllerProvider
        self.navigationIntentHandler = NavigationIntentHandler(flowControllerProvider: flowControllerProvider,
                                                               userStatusProvider: userStatusProvider,
                                                               navigationTransitionerDataSource: navigationTransitionerDataSource)
        self.settings = settings
        self.userStatusProvider = userStatusProvider
        self.urlGateway = URLGateway(settings: settings)
    }
    
    @discardableResult
    public func handleURL(_ url: URL) -> Future<Bool> {
        let promise = Promise<Bool>()
        urlGateway.handleURL(url).finally { future in
            switch future.state {
            case .result(let deepLink):
                self.openDeepLink(deepLink).finally { future in
                    promise.setResolution(of: future)
                }
                
            case .error(let error):
                let wrappedError = NSError(domain: DeepLinkingFacade.domain, code: ErrorCode.couldNotHandleURL.rawValue, userInfo: [NSUnderlyingErrorKey: error])
                promise.setError(wrappedError)
                
            default:
                let error = NSError(domain: DeepLinkingFacade.domain, code: ErrorCode.couldNotHandleURL.rawValue, userInfo: nil)
                promise.setError(error)
            }
        }
        return promise.future
    }
    
    @discardableResult
    public func openDeepLink(_ deepLink: DeepLink) -> Future<Bool> {
        let result = NavigationIntentFactory().intent(for: deepLink)
        switch result {
        case .result(let intent):
            return self.navigationIntentHandler.handleIntent(intent)
        case .error(let error):
            let wrappedError = NSError(domain: DeepLinkingFacade.domain, code: ErrorCode.couldNotHandleDeepLink.rawValue, userInfo: [NSUnderlyingErrorKey: error])
            return Future<Bool>.future(withError: wrappedError)
        }
    }
    
    @discardableResult
    public func openShortcutItem(_ item: UIApplicationShortcutItem) -> Future<Bool> {
        let shortcutItemConverter = ShortcutItemConverter(settings: settings)
        if let deepLink = shortcutItemConverter.deepLink(forShortcutItem: item) {
            return openDeepLink(deepLink)
        }
        else {
            let error = NSError(domain: DeepLinkingFacade.domain, code: ErrorCode.couldNotDeepLinkFromShortcutItem.rawValue, userInfo: nil)
            return Future<Bool>.future(withError: error)
        }
    }
    
    @discardableResult
    public func openSpotlightItem(_ userActivity: NSUserActivityProtocol) -> Future<Bool> {
        let spotlightItemConverter = SpotlightItemConverter(settings: settings)
        if let deepLink = spotlightItemConverter.deepLink(forSpotlightItem: userActivity) {
            return openDeepLink(deepLink)
        }
        else {
            let error = NSError(domain: DeepLinkingFacade.domain, code: ErrorCode.couldNotDeepLinkFromSpotlightItem.rawValue, userInfo: nil)
            return Future<Bool>.future(withError: error)
        }
    }
}
