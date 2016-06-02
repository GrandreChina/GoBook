//
//  AppDelegate.swift
//  GoBook
//
//  Created by Grandre on 16/3/23.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarController:UITabBarController!
  
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        ShareSDK.registerApp("12b221b378327", activePlatforms: [SSDKPlatformType.SubTypeWechatSession.rawValue,SSDKPlatformType.SubTypeWechatTimeline.rawValue], onImport: { (platForm) -> Void in
//            SSDKPlatformType.TypeQQ.rawValue，
//            SSDKPlatformType.TypeSinaWeibo.rawValue
//            SSDKPlatformType.TypeWechat.rawValue包括微信好友，朋友圈，收藏夹
//            SSDKPlatformType.SubTypeWechatSession.rawValue 微信好友
//            SSDKPlatformType.SubTypeWechatTimeline.rawValue 朋友圈
            switch platForm{
            case SSDKPlatformType.TypeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            default :
                break
            }
            }) { (platform, appinfo) -> Void in
                
                switch platform{
                case SSDKPlatformType.TypeWechat:
                    appinfo.SSDKSetupWeChatByAppId("wxb642a2165a1d882b", appSecret: "64a981cfca6af6bbf06be56ff65faaf9")
                default:
                    break
                }

        }
        
        
        
        AVOSCloud.setApplicationId("CjS7oTWcC8ueW8Fd5dnQ8jqq-gzGzoHsz", clientKey: "8QXdSy63wG9d6IHbdJWDIiH8")
     
        self.window = UIWindow(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT))
        self.tabbarController = UITabBarController()
        
        let rankController = UINavigationController(rootViewController: rankViewController())
        let searchController = UINavigationController(rootViewController: searchViewController())
        let pushController = UINavigationController(rootViewController: pushViewController())
        let circleController = UINavigationController(rootViewController: circleViewController())
        let moreController = UINavigationController(rootViewController: moreViewController())

        rankController.tabBarItem = UITabBarItem(title: "排行榜", image: UIImage(named: "bio"), selectedImage: UIImage(named: "bio_red"))
        searchController.tabBarItem = UITabBarItem(title: "发现", image: UIImage(named: "tabbar_discover"), selectedImage: UIImage(named: "tabbar_discoverHL"))
        pushController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "pencil"), selectedImage: UIImage(named: "pencle_red"))
        circleController.tabBarItem = UITabBarItem(title: "圈子", image: UIImage(named: "users two-2"), selectedImage: UIImage(named: "users two-2_red"))
        moreController.tabBarItem = UITabBarItem(title: "更多", image: UIImage(named: "more"), selectedImage: UIImage(named: "more_red"))
       
        tabbarController.tabBar.tintColor = MAIN_RED
        
        
        tabbarController.viewControllers = [rankController,searchController,pushController,circleController,moreController]
        
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
        
        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

