//
//  StateMachineTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
import Stateful
@testable import NavigationEngineDemo

extension Transition: Equatable {
    
    public static func == (lhs: Transition<State, Event>, rhs: Transition<State, Event>) -> Bool {
        return lhs.source as! StateType == rhs.source as! StateType &&
            lhs.event as! EventType == rhs.event as! EventType
        // don't do the equality on the destination since the ST only allows adding one event given a source state
    }
}

class StateMachineTests: XCTestCase {
    
    func test_onlyBasicTransitionsAreAllowed() {
        let options: TransitionOptions = [.basicTransitions]
        allowedTransitions(basicTransitions, options: options)
    }
    
    func test_onlyBasicAndUserLoggedInTransitionsAreAllowed() {
        let options: TransitionOptions = [.basicTransitions, .userLoggedIn]
        allowedTransitions(basicTransitions + userLoggedInTransitions, options: options)
    }
    
    func test_onlyBasicAndUserLoggedOutTransitionsAreAllowed() {
        let options: TransitionOptions = [.basicTransitions, .userLoggedOut]
        allowedTransitions(basicTransitions + userLoggedOutTransitions, options: options)
    }
    
    private func allowedTransitions(_ transitions: [Transition<StateType, EventType>], options: TransitionOptions) {
        for s1 in 0..<StateType.allCases.count {
            for s2 in 0..<StateType.allCases.count {
                let state1 = StateType(rawValue: s1)!
                let state2 = StateType(rawValue: s2)!
                for i in 0..<EventType.allCases.count {
                    let e = EventType(rawValue: i)!
                    let t = Transition<StateType, EventType>(with: e, from: state1, to: state2)
                    let sm = StateMachine(initialState: state1, allowedTransitions: options)
                    sm.process(event: e, execution: nil) { result in
                        if transitions.contains(t) {
                            XCTAssert(result == .success)
                        }
                        else {
                            XCTAssert(result == .failure)
                        }
                    }
                }
            }
        }
    }
    
    lazy var basicTransitions: [Transition<StateType, EventType>] = {
        var transitions = [Transition<StateType, EventType>]()
        transitions.append(Transition<StateType, EventType>(with: .goToHome,
                                                            from: .allPoppedToRoot,
                                                            to: .home))
        transitions.append(Transition<StateType, EventType>(with: .searchRestaurants,
                                                            from: .home,
                                                            to: .search))
        transitions.append(Transition<StateType, EventType>(with: .loadRestaurant,
                                                            from: .home,
                                                            to: .restaurant))
        transitions.append(Transition<StateType, EventType>(with: .loadRestaurant,
                                                            from: .search,
                                                            to: .restaurant))
        transitions.append(Transition<StateType, EventType>(with: .goToSettings,
                                                            from: .allPoppedToRoot,
                                                            to: .settings))
        
        // make sure we can always go back to root
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .allPoppedToRoot,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .home,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .resetPassword,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .search,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .restaurant,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .orderHistory,
                                                            to: .allPoppedToRoot))
        transitions.append(Transition<StateType, EventType>(with: .popEverything,
                                                            from: .orderDetails,
                                                            to: .allPoppedToRoot))
        return transitions
    }()
    
    lazy var userLoggedInTransitions: [Transition<StateType, EventType>] = {
        var transitions = [Transition<StateType, EventType>]()
        transitions.append(Transition<StateType, EventType>(with: .loadOrderHistory,
                                                            from: .allPoppedToRoot,
                                                            to: .orderHistory))
        transitions.append(Transition<StateType, EventType>(with: .fillBasket,
                                                            from: .restaurant,
                                                            to: .basket))
        transitions.append(Transition<StateType, EventType>(with: .goToOrderDetails,
                                                            from: .orderHistory,
                                                            to: .orderDetails))
        return transitions
    }()
    
    lazy var userLoggedOutTransitions: [Transition<StateType, EventType>] = {
        var transitions = [Transition<StateType, EventType>]()
        transitions.append(Transition<StateType, EventType>(with: .goToResetPassword,
                                                            from: .allPoppedToRoot,
                                                            to: .resetPassword))
        transitions.append(Transition<StateType, EventType>(with: .goToLogin,
                                                            from: .allPoppedToRoot,
                                                            to: .login))
        return transitions
    }()
}
