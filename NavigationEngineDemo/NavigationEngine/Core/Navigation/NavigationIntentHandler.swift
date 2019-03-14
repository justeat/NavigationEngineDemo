//
//  IntentHandler.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 24/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

public class NavigationIntentHandler: NavigationIntentHandling {
    
    let flowControllerProvider: FlowControllerProvider
    let userStatusProvider: UserStatusProviding!
    private let navigationTransitionerDataSource: NavigationTransitionerDataSource
    var navigationTransitioner: NavigationTransitioner!
    
    init(flowControllerProvider: FlowControllerProvider, userStatusProvider: UserStatusProviding, navigationTransitionerDataSource: NavigationTransitionerDataSource) {
        self.flowControllerProvider = flowControllerProvider
        self.userStatusProvider = userStatusProvider
        self.navigationTransitionerDataSource = navigationTransitionerDataSource
    }
    
    func handleIntent(_ intent: NavigationIntent) -> Future<Bool> {
        let allowedTransitions: TransitionOptions = {
            switch userStatusProvider.userStatus {
            case .loggedIn:
                return [.basicTransitions, .userLoggedIn]
            case .loggedOut:
                return [.basicTransitions, .userLoggedOut]
            }
        }()
        
        let stateMachine = StateMachine(initialState: StateType.allPoppedToRoot, allowedTransitions: allowedTransitions)
        navigationTransitioner = NavigationTransitioner(flowControllerProvider: flowControllerProvider, stateMachine: stateMachine)
        navigationTransitioner.dataSource = navigationTransitionerDataSource
        
        switch intent {
        case .goToHome:
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToHome(animated: false)
            }
        case .goToLogin:
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToLogin(animated: true)
            }
        case .goToResetPassword(let token):
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToResetPassword(token: token, animated: true)
            }
        case .goToSearch(let postcode, let cuisine):
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToHome(animated: false)
                }.thenWithResult { _ -> Future<Bool> in
                    self.navigationTransitioner.goFromHomeToSearch(postcode: postcode, cuisine: cuisine, animated: true)
            }
        case .goToRestaurant(let restaurantId, let postcode, let serviceType, let section):
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToHome(animated: false)
                }.thenWithResult { _ -> Future<Bool> in
                    self.navigationTransitioner.goFromHomeToRestaurant(restaurantId: restaurantId, postcode: postcode, serviceType: serviceType, section: section, animated: true)
            }
        case .goToReorder(let reorderId):
            switch userStatusProvider.userStatus {
            case .loggedIn:
                return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                    self.navigationTransitioner.goToHome(animated: false)
                    }.thenWithResult { _ -> Future<ReorderInfo> in
                        self.navigationTransitioner.requestInputForReorder(orderId: reorderId)
                    }.thenWithResult { reorderInfo -> Future<Bool> in
                        self.navigationTransitioner.goFromHomeToRestaurant(restaurantId: reorderInfo.restaurantId,
                                                                           postcode: reorderInfo.postcode,
                                                                           serviceType: reorderInfo.serviceType,
                                                                           section: .menu,
                                                                           animated: false)
                    }.thenWithResult { _ -> Future<Bool> in
                        self.navigationTransitioner.goFromRestaurantToBasket(reorderId: reorderId, animated: true)
                }
            case .loggedOut:
                return navigationTransitioner.requestUserToLogin().then { future in
                    switch future.state {
                    case .result:
                        return self.handleIntent(intent) // go recursive
                    default:
                        return Future<Bool>.futureWithResolution(of: future)
                    }
                }
            }
        case .goToOrderHistory:
            switch userStatusProvider.userStatus {
            case .loggedIn:
                return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                    self.navigationTransitioner.goToOrderHistory(animated: true)
                }
            case .loggedOut:
                return navigationTransitioner.requestUserToLogin().then { future in
                    switch future.state {
                    case .result:
                        return self.handleIntent(intent) // go recursive
                    default:
                        return Future<Bool>.futureWithResolution(of: future)
                    }
                }
            }
        case .goToOrderDetails(let orderId):
            switch userStatusProvider.userStatus {
            case .loggedIn:
                return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                    self.navigationTransitioner.goToOrderHistory(animated: false)
                    }.thenWithResult { _ -> Future<Bool> in
                        self.navigationTransitioner.goFromOrderHistoryToOrderDetails(orderId: orderId, animated: true)
                }
            case .loggedOut:
                return navigationTransitioner.requestUserToLogin().then { future in
                    switch future.state {
                    case .result:
                        return self.handleIntent(intent) // go recursive
                    default:
                        return Future<Bool>.futureWithResolution(of: future)
                    }
                }
            }
        case .goToSettings:
            return navigationTransitioner.goToRoot(animated: false).thenWithResult { _ -> Future<Bool> in
                self.navigationTransitioner.goToSettings(animated: false)
            }
        }
    }
}
