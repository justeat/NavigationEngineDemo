//
//  StateMachine.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 25/12/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import Foundation
import Stateful

struct TransitionOptions: OptionSet {
    let rawValue: Int
    
    static let basicTransitions = TransitionOptions(rawValue: 1 << 0)
    static let userLoggedIn     = TransitionOptions(rawValue: 1 << 1)
    static let userLoggedOut    = TransitionOptions(rawValue: 1 << 2)
}

enum EventType: Int, CaseIterable {
    case popEverything
    case goToHome
    case goToLogin
    case goToResetPassword
    case searchRestaurants
    case loadRestaurant
    case fillBasket
    case loadOrderHistory
    case goToOrderDetails
    case goToSettings
}

enum StateType: Int, CaseIterable {
    case allPoppedToRoot
    case home
    case login
    case resetPassword
    case search
    case basket
    case restaurant
    case orderHistory
    case orderDetails
    case settings
}

class StateMachine: Stateful.StateMachine<StateType, EventType> {
    
    init(initialState: StateType, allowedTransitions: TransitionOptions) {
        super.init(initialState: initialState)
        
        if allowedTransitions.contains(.basicTransitions) {
            addBasicTransitions()
        }
        
        if allowedTransitions.contains(.userLoggedIn) {
            addUserLoggedInTransitions()
        }
        
        if allowedTransitions.contains(.userLoggedOut) {
            addUserLoggedOutTransitions()
        }
    }
    
    func addBasicTransitions() {
        add(transition: Transition<StateType, EventType>(with: .goToHome,
                                                         from: .allPoppedToRoot,
                                                         to: .home))
        add(transition: Transition<StateType, EventType>(with: .searchRestaurants,
                                                         from: .home,
                                                         to: .search))
        add(transition: Transition<StateType, EventType>(with: .loadRestaurant,
                                                         from: .home,
                                                         to: .restaurant))
        add(transition: Transition<StateType, EventType>(with: .loadRestaurant,
                                                         from: .search,
                                                         to: .restaurant))
        add(transition: Transition<StateType, EventType>(with: .goToSettings,
                                                         from: .allPoppedToRoot,
                                                         to: .settings))
        
        // make sure we can always go back to root
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .allPoppedToRoot,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .home,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .resetPassword,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .search,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .restaurant,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .orderHistory,
                                                         to: .allPoppedToRoot))
        add(transition: Transition<StateType, EventType>(with: .popEverything,
                                                         from: .orderDetails,
                                                         to: .allPoppedToRoot))
    }
    
    func addUserLoggedInTransitions() {
        add(transition: Transition<StateType, EventType>(with: .loadOrderHistory,
                                                         from: .allPoppedToRoot,
                                                         to: .orderHistory))
        add(transition: Transition<StateType, EventType>(with: .goToOrderDetails,
                                                         from: .orderHistory,
                                                         to: .orderDetails))
        add(transition: Transition<StateType, EventType>(with: .fillBasket,
                                                         from: .restaurant,
                                                         to: .basket))
    }
    
    func addUserLoggedOutTransitions() {
        add(transition: Transition<StateType, EventType>(with: .goToResetPassword,
                                                         from: .allPoppedToRoot,
                                                         to: .resetPassword))
        add(transition: Transition<StateType, EventType>(with: .goToLogin,
                                                         from: .allPoppedToRoot,
                                                         to: .login))
    }
}
