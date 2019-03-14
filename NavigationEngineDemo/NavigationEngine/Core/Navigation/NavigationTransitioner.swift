//
//  NavigationTransitioner.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 26/12/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import Foundation
import Stateful
import Promis

public protocol NavigationTransitionerDataSource: class {
    
    func navigationTransitionerDidRequestInputForReorder(orderId: OrderId) -> Future<ReorderInfo>
    func navigationTransitionerDidRequestUserToLogin() -> Future<Bool>
}

class NavigationTransitioner {
    
    weak var dataSource: NavigationTransitionerDataSource!
    
    let flowControllerProvider: FlowControllerProvider
    let stateMachine: StateMachine
    
    static let domain = "com.justeat.navigationTransitioner"
    
    enum ErrorCode: Int {
        case failedPerformingTransition
    }
    
    init(flowControllerProvider: FlowControllerProvider, stateMachine: StateMachine) {
        self.flowControllerProvider = flowControllerProvider
        self.stateMachine = stateMachine
    }
    
    func goToRoot(animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .popEverything, autoclosure:
            self.flowControllerProvider.rootFlowController.dismissAndPopToRootAll(animated: animated)
        )
    }
    
    func goToHome(animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .goToHome, autoclosure:
            self.flowControllerProvider.rootFlowController.goToRestaurantsSection()
        )
    }
    
    func goToLogin(animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .goToLogin, autoclosure:
            self.flowControllerProvider.rootFlowController.goToLogin(animated: animated)
        )
    }
    
    func goToResetPassword(token: ResetPasswordToken, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .goToResetPassword, autoclosure:
            self.flowControllerProvider.rootFlowController.goToResetPassword(token: token, animated: animated)
        )
    }
    
    func goFromHomeToSearch(postcode: Postcode?, cuisine: Cuisine?, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .searchRestaurants, autoclosure:
            self.flowControllerProvider.restaurantsFlowController.goToSearchAnimated(postcode: postcode, cuisine: cuisine, animated: animated)
        )
    }
    
    func goFromHomeToRestaurant(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .loadRestaurant, autoclosure:
            self.flowControllerProvider.restaurantsFlowController.goToRestaurant(restaurantId: restaurantId, postcode: postcode, serviceType: serviceType, section: section, animated: animated)
        )
    }
    
    func goFromSearchToRestaurant(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .loadRestaurant, autoclosure:
            self.flowControllerProvider.restaurantsFlowController.goToRestaurant(restaurantId: restaurantId, postcode: postcode, serviceType: serviceType, section: section, animated: animated)
        )
    }
    
    func goFromRestaurantToBasket(reorderId: ReorderId, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .fillBasket, autoclosure:
            self.flowControllerProvider.restaurantsFlowController.goToBasket(reorderId: reorderId, animated: animated)
        )
    }
    
    func goToOrderHistory(animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .loadOrderHistory, autoclosure:
            self.flowControllerProvider.rootFlowController.goToOrdersSection()
        )
    }
    
    func goFromOrderHistoryToOrderDetails(orderId: OrderId, animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .goToOrderDetails, autoclosure:
            self.flowControllerProvider.ordersFlowController.goToOrder(orderId: orderId, animated: animated)
        )
    }
    
    func goToSettings(animated: Bool) -> Future<Bool> {
        return performTransition(forEvent: .goToSettings, autoclosure:
            self.flowControllerProvider.rootFlowController.goToSettingsSection()
        )
    }
    
    func requestInputForReorder(orderId: OrderId) -> Future<ReorderInfo> {
        return dataSource.navigationTransitionerDidRequestInputForReorder(orderId: orderId)
    }
    
    func requestUserToLogin() -> Future<Bool> {
        return dataSource.navigationTransitionerDidRequestUserToLogin()
    }
}

extension NavigationTransitioner {
    
    fileprivate func performTransition(forEvent eventType: EventType, autoclosure: @autoclosure @escaping () -> Future<Bool>) -> Future<Bool> {
        let promise = Promise<Bool>()
        stateMachine.process(event: eventType, execution: {
            autoclosure().finally { future in
                promise.setResolution(of: future)
            }
        }, callback: { result in
            /**
             * If result == .success (i.e. the transition was performed):
             - the callback block is called twice
             - the `execution` block is called
             * If result == .failure (i.e. the transition cannot be performed):
             - the callback block is called once
             - the `execution` block is not called
             * We cannot therefore resolve the promise in case of success otherwise we would do it twice causing a crash.
             */
            if result == .failure {
                let error = NSError(domain: NavigationTransitioner.domain,
                                    code: ErrorCode.failedPerformingTransition.rawValue,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: "Could not perform transition"])
                promise.setError(error)
            }
        })
        return promise.future
    }
}
