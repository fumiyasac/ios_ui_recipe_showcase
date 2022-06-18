//
//  AppDelegate.swift
//  InteractiveUIExample
//
//  Created by 酒井文也 on 2018/08/10.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

// 本サンプルにおいて現状非対応にしている、または最低限の対応だけに留めている部分は下記の通り
// 1. DarkMode: 現状ではDarkModeをキャンセルしています。
// 2. UISceneAPI: 現状挙動への問題はないがiOS13以降では非推奨となっています。

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MEMO: DarkModeのキャンセル
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        // MEMO: iOS15に関する配色に関する調整対応
        // ※ CustomTransiitionの実行とダミーのNavigationBarを配置している関係でこの場合はUINavigationBarAppearanceの設定は不要

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
