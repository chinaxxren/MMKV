//
//  Router.swift
//  Base
//
//  Created by 赵江明 on 2022/1/15.
//



import UIKit

public protocol Navigation { }

public protocol AppNavigation {
    func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController
    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController)
}

public protocol NavRouter {
    func setupAppNavigation(appNavigation: AppNavigation)
    func navigate(_ navigation: Navigation, from: UIViewController) -> UIViewController
    func didNavigate(block: @escaping (Navigation) -> Void)
    var appNavigation: AppNavigation? { get }
}

public extension UIViewController {
    func navigate(_ navigation: Navigation) -> UIViewController {
        return RouterManager.shared.navigate(navigation, from: self)
    }
}

public class RouterManager: NavRouter {
    public static let shared = RouterManager()
    
    public var appNavigation: AppNavigation?
    var didNavigateBlocks = [((Navigation) -> Void)] ()
    
    public func setupAppNavigation(appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
    
    @discardableResult public func nav(_ navigation: Navigation) -> UIViewController {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return UIViewController()
        }
        
        let topVC = Self.top(rootVC: rootVC)
        guard let vc = topVC else {
            return UIViewController()
        }
        
        return self.navigate(navigation, from: vc)
    }
    
    @discardableResult public func navigate(_ navigation: Navigation, from: UIViewController) -> UIViewController {
        guard let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) else {
            fatalError("Init ViewController failed")
        }
        appNavigation?.navigate(navigation, from: from, to: toVC)
        for b in didNavigateBlocks {
            b(navigation)
        }
        return toVC
    }
    
    public func didNavigate(block: @escaping (Navigation) -> Void) {
        didNavigateBlocks.append(block)
    }
    
    // MARK: 1.3、获取顶部控制器(类方法)
    /// 获取顶部控制器
    /// - Returns: VC
    static func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return top(rootVC: rootVC)
    }
    
    // MARK: 1.4、获取顶部控制器(实例方法)
    /// 获取顶部控制器
    /// - Returns: VC
    func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return Self.top(rootVC: rootVC)
    }
    
    private static func top(rootVC: UIViewController?) -> UIViewController? {
        if let presentedVC = rootVC?.presentedViewController {
            return top(rootVC: presentedVC)
        }
        if let nav = rootVC as? UINavigationController,
            let lastVC = nav.viewControllers.last {
            return top(rootVC: lastVC)
        }
        if let tab = rootVC as? UITabBarController,
            let selectedVC = tab.selectedViewController {
            return top(rootVC: selectedVC)
        }
        return rootVC
    }
}

// Injection helper
public protocol Initializable { init() }
open class RuntimeInjectable: NSObject, Initializable {
    public required override init() {}
}

public func appNavigationFromString(_ appNavigationClassString: String) -> AppNavigation {
    let appNavClass = NSClassFromString(appNavigationClassString) as! RuntimeInjectable.Type
    let appNav = appNavClass.init()
    return appNav as! AppNavigation
}
