//
//  AppDelegate.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 25/12/2018.
//  Copyright (c) 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis
import CoreSpotlight
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userInputController: UserInputController!
    var rootFlowController: RootFlowController!
    var deepLinkingFacade: DeepLinkingFacade!
    
    var userStatusProvider = UserStatusProvider()
    let deepLinkingSettings = DeepLinkingSettings()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        // Init UI Stack
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = TabBarController.instantiate()
        
        // Root Flow Controller
        rootFlowController = RootFlowController(with: tabBarController)
        tabBarController.flowController = rootFlowController
        
        userStatusProvider.userStatus = .loggedOut
        
        // DeepLinking core
        let flowControllerProvider = FlowControllerProvider(rootFlowController: rootFlowController)
        deepLinkingFacade = DeepLinkingFacade(flowControllerProvider: flowControllerProvider,
                                              navigationTransitionerDataSource: self,
                                              settings: deepLinkingSettings,
                                              userStatusProvider: userStatusProvider)
        userInputController = UserInputController(userStatusProvider: userStatusProvider)
        
        updateShortcutItems()
        addSpotlightItem()
        
        // Complete UI Stack
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        setupDeepLinkingTesterViewController()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // from internal deepLinks & TodayExtension
        deepLinkingFacade.openDeepLink(url).finally { future in
            self.handleFuture(future, originalInput: url.absoluteString)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        switch userActivity.activityType {
        // from Safari
        case NSUserActivityTypeBrowsingWeb:
            if let webpageURL = userActivity.webpageURL {
                self.deepLinkingFacade.handleURL(webpageURL).finally { future in
                    self.handleFuture(future, originalInput: webpageURL.absoluteString)
                }
                return true
            }
            return false
            
        // from Spotlight
        case CSSearchableItemActionType:
            self.deepLinkingFacade.openSpotlightItem(userActivity).finally { future in
                let input = userActivity.userInfo![CSSearchableItemActivityIdentifier] as! String
                self.handleFuture(future, originalInput: input)
            }
            return true
            
        default:
            return false
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // from shortcut items
        deepLinkingFacade.openShortcutItem(shortcutItem).finally { future in
            let input = shortcutItem.type
            self.handleFuture(future, originalInput: input)
            completionHandler(future.hasResult())
        }
    }
}

extension AppDelegate {
    
    func handleFuture(_ future: Future<Bool>, originalInput input: String) {
        switch future.state {
        case .result:
            print("[DeepLinkingFacade] ✅ Executed deepLinking with input: '\(input)'")
            self.showAlert(title: "✅ Navigation Engine", message: "Executed deepLinking with input:\n'\(input)'")
        case .error(let error):
            print("[DeepLinkingFacade] ❌ Failed deepLinking with input: '\(input)' with error:\n\(error)")
            self.showAlert(title: "❌ Navigation Engine", message: "Failed deepLinking with input:\n'\(input)'\nerror: \(error)")
        default:
            print("[DeepLinkingFacade] ❌ Failed deepLinking with input: '\(input)'")
            self.showAlert(title: "❌ Navigation Engine", message: "Failed deepLinking with input:\n'\(input)'")
        }
    }
}

extension AppDelegate: NavigationTransitionerDataSource {
    
    func navigationTransitionerDidRequestInputForReorder(orderId: OrderId) -> Future<ReorderInfo> {
        return userInputController.gatherReorderUserInput()
    }
    
    func navigationTransitionerDidRequestUserToLogin() -> Future<Bool> {
        return userInputController.promptUserForLogin()
    }
}

extension AppDelegate {
    
    func updateShortcutItems() {
        guard UIScreen.main.traitCollection.forceTouchCapability == .available else { return }
        
        UIApplication.shared.shortcutItems = {
            let item1 = UIMutableApplicationShortcutItem(type: "/search", localizedTitle: "Search")
            let item2 = UIMutableApplicationShortcutItem(type: "/orderHistory", localizedTitle: "Orders")
            let item3 = UIMutableApplicationShortcutItem(type: "/reorder/123", localizedTitle: "Reorder")
            let item4 = UIMutableApplicationShortcutItem(type: "unknown", localizedTitle: "Unknown")
            return [item1, item2, item3, item4]
        }()
    }
    
    func addSpotlightItem() {
        guard CSSearchableIndex.isIndexingAvailable() else { return }
        
        let domainIdentifier = "com.justeat.AppDelegate"
        
        // Order
        let attributeSet1 = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
        attributeSet1.title = "Test order 123"
        
        attributeSet1.displayName = "Go to order details"
        attributeSet1.contentDescription = "Some description"
        attributeSet1.domainIdentifier = domainIdentifier
        
        attributeSet1.relatedUniqueIdentifier = "123"
        
        attributeSet1.path = "/orderDetails/123"
        attributeSet1.keywords = ["test order", "navigation engine"]
        let item1 = CSSearchableItem(uniqueIdentifier: "/orderDetails/123", domainIdentifier: domainIdentifier, attributeSet: attributeSet1)
        
        // Restaurant
        let attributeSet2 = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
        attributeSet2.title = "Test restaurant 456"
        
        attributeSet2.displayName = "Go to restaurant details"
        attributeSet2.contentDescription = "Some description"
        attributeSet2.domainIdentifier = domainIdentifier
        
        attributeSet2.relatedUniqueIdentifier = "456"
        
        attributeSet2.path = "/restaurant/456"
        attributeSet2.keywords = ["test restaurant", "navigation engine"]
        let item2 = CSSearchableItem(uniqueIdentifier: "/restaurant/456", domainIdentifier: domainIdentifier, attributeSet: attributeSet2)
        
        // Invalid
        let attributeSet3 = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
        attributeSet3.title = "Invalid"
        attributeSet3.path = "gibberish"
        attributeSet3.keywords = ["test order", "navigation engine"]
        attributeSet3.domainIdentifier = domainIdentifier
        let item3 = CSSearchableItem(uniqueIdentifier: "unknown", domainIdentifier: domainIdentifier, attributeSet: attributeSet3)
        
        CSSearchableIndex.default().indexSearchableItems([item1, item2, item3]) { _ in }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        window?.rootViewController?.show(alert, sender: nil)
    }
}

extension AppDelegate {
    
    func setupDeepLinkingTesterViewController() {
        let tabBarController = window!.rootViewController as! TabBarController
        let deepLinkingTesterViewController = tabBarController.viewControllers![3] as! DeepLinkingTesterViewController
        deepLinkingTesterViewController.delegate = self
        let path = Bundle.main.path(forResource: "deeplinking_test_list", ofType: "json")!
        deepLinkingTesterViewController.loadTestLinks(atPath: path)
    }
}

extension AppDelegate: DeepLinkingTesterViewControllerDelegate {
    
    func deepLinkingTesterViewController(_ deepLinkingTesterViewController: DeepLinkingTesterViewController, didSelect url: URL) {
        // to explicitly test the Universal Link appDelegate callback
        // this assumes the apple-app-site-association is reachable at the root of the website
        // and the app has configured associated domains in capabilities
//        if url.scheme! == "http" || url.scheme! == "https" {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
        // DeepLinkg
        self.deepLinkingFacade.handleURL(url).finally { future in
            self.handleFuture(future, originalInput: url.absoluteString)
        }
    }
}
