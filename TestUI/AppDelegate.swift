//
//  AppDelegate.swift
//  TestUI
//
//  Created by li on 2021/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var naviContoller:MTNavigationViewController!
    
    var timer:Timer!

    func applicationWillResignActive(_ application: UIApplication) {
        
        EBLogAnalyticManager.sharedInstance().forceStoreLogs()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        EBLogAnalyticManager.sharedInstance().forceUpdateLogs()
    }
    
    func testLogs() -> Void {
        
        EBLogAnalyticManager.sharedInstance().run()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { Timer in
        
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                EBLogAnalyticManager.sharedInstance().saveLog(["eventId":105456, "msg":"登陆事件"])
            }
        }
        
        timer.fire()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        
        EBUncaughtExceptionHandler.run()
    
        TestManager.test()
        
//        testLogs()
        
//        EBUncaughtExceptionHandler.uploadCrashLogFile()
        
        return true
    }
    
    func setupWindow() -> Void {
        
        window = UIWindow()
        
        let vc = ViewController()
        
        naviContoller = MTNavigationViewController(rootViewController: vc)
        
        window?.rootViewController = naviContoller
        
        window?.makeKeyAndVisible()
    }
    
    func test() -> Void {
        
        
    }
}

