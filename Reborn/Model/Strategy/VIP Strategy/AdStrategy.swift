//
//  AdStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 29/3/21.
//

import Foundation
import UIKit
import GoogleMobileAds
class AdStrategy: VIPStrategyImpl {
    func addAd(to viewController: UIViewController) {
        
        if AppEngine.shared.currentUser.isVip {
            
        } else {
            
            if let tabBarController = viewController as? UITabBarController {
                
                var bannerView: GADBannerView!
                bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                bannerView.accessibilityIdentifier = "BottomBannerAd"
                bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                bannerView.rootViewController = tabBarController
                bannerView.load(GADRequest())
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                viewController.view.addSubview(bannerView)
                
                bannerView.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor).isActive = true
                bannerView.centerXAnchor.constraint(equalTo: tabBarController.view.centerXAnchor).isActive = true
                bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
                bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
            } else {
                
                var bannerView: GADBannerView!
                bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                bannerView.accessibilityIdentifier = "BottomBannerAd"
                bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                bannerView.rootViewController = viewController
                bannerView.load(GADRequest())
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                viewController.view.addSubview(bannerView)
                
                bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
                bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
                bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
                bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
    
            
        }
       
    }
    
    func removeAd(from viewController: UIViewController) {
        if AppEngine.shared.currentUser.isVip {
            viewController.view.removeSubviewBy(idenifier: "BottomBannerAd")
        }
        
    }
}
