//
//  BaseNavigation.swift
//  Base
//
//  Created by 赵江明 on 2022/1/15.
//

import XCoordinator

enum AppRoute :Route {
    case home
    case second
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    init() {
        super.init(initialRoute: .home)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            let vc = ViewController()
            return .push(vc)
        case .second:
            let vc = SecondController()
            return .push(vc)
        }
    }
}

