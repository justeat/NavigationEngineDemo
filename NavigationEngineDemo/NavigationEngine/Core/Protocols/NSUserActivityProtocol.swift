//
//  NSUserActivityProtocol.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 11/02/2019.
//

import Foundation

public protocol NSUserActivityProtocol {
    
    var activityType: String { get }
    var userInfo: [AnyHashable: Any]? { get }
}
