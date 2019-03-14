//
//  RestaurantsFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

public protocol RestaurantsFlowControllerProtocol {

    var checkoutFlowController: CheckoutFlowControllerProtocol! { get }
    var parentFlowController: RootFlowControllerProtocol! { get }

    @discardableResult func dismiss(animated: Bool) -> Future<Bool>
    @discardableResult func goBackToRoot(animated: Bool) -> Future<Bool>
    @discardableResult func goToSearchAnimated(postcode: Postcode?, cuisine: Cuisine?, animated: Bool) -> Future<Bool>
    @discardableResult func goToRestaurant(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?, animated: Bool) -> Future<Bool>
    @discardableResult func goToBasket(reorderId: ReorderId, animated: Bool) -> Future<Bool>
    @discardableResult func goToCheckout(animated: Bool) -> Future<Bool>
}
