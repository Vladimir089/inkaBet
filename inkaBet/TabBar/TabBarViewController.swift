//
//  TabBarViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit

var person: User?
var kcalToday = 0
var achivementCompleted = 0
var achivementArr: [Bool] = [] //массив который будет содержать какое достижение выполнилось а какое нет вида [false, false, false, true] и тд

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        settingsTab()
        
        UserDefaults.standard.setValue(true, forKey: "onbUser")
    }
    
    
    
    func settingsTab() {
        
        let statVC = StatisticsViewController()
        let onetabItem = UITabBarItem(title: "", image: .stat.resize(targetSize: CGSize(width: 44, height: 44)), tag: 0)
        onetabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        onetabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        statVC.tabBarItem = onetabItem
        
        
        
        self.tabBar.backgroundColor = .BG
        self.tabBar.tintColor = .primary
        self.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.3)
        tabBar.layer.cornerRadius = 20
        
        
        
        let personVC = ProfileViewController()
        let twoTabItem = UITabBarItem(title: "", image: .person.resize(targetSize: CGSize(width: 20, height: 21)), tag: 1)
        twoTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        twoTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        personVC.tabBarItem = twoTabItem
        
        
        
        viewControllers = [statVC, personVC]
        
    }
    

   
    func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: "userProfile") {
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                person = user
            } catch {
                print("Failed to load user: \(error)")
            }
        }
    }
}
