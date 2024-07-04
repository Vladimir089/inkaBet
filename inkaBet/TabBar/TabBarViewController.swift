//
//  TabBarViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit

var person: User?
var kcalToday: CGFloat = 0

//ach
var achivementArr: [Bool] = [false, false, false, false, false, false, false]
var imageArr = [UIImage.a1, UIImage.a2, UIImage.a3, UIImage.a4, UIImage.a5, UIImage.a6, UIImage.a7]
var textAchivArr = ["Complete your first training session", "Complete at least 5 training sessions", "Complete at least 10 training sessions", "Complete at least 15 training sessions", "Complete at least 20 training sessions", "Complete at least 25 training sessions", "The total amount of training time should exceed 40 hours"]

//workout
var workArr: [Workout] = []

//next




class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWork()
        loadUser()
        loadAch()
        
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
        
        let workoutVC = WorkoutViewController()
        let threeTabItem = UITabBarItem(title: "", image: .work.resize(targetSize: CGSize(width: 23, height: 23)), tag: 1)
        threeTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        threeTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        workoutVC.tabBarItem = threeTabItem
        
        
        
        viewControllers = [workoutVC, statVC, personVC]
        selectedIndex = 1
        
    }
    
    
    
    func loadAch() {
        
        if let userData = UserDefaults.standard.array(forKey: "ach") {
            achivementArr = userData as? [Bool] ?? [false, false, false, false, false, false, false]
        }
    }
    
    
    func loadWork() {
        if let userData = UserDefaults.standard.data(forKey: "work") {
            do {
                let work = try JSONDecoder().decode([Workout].self, from: userData)
                workArr = work
                
                for i in workArr {
                    kcalToday += i.calories
                }
                
                
                
            } catch {
                print("Failed to load user: \(error)")
            }
        }
        
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
