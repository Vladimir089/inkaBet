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

protocol TabBarViewControllerDelegate: AnyObject {
    func openVC(index: Int)
}


class TabBarViewController: UITabBarController {
    
    let calendar = Calendar.current
    let today = Date()

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
//        onetabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
//        onetabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        statVC.tabBarItem = onetabItem
        statVC.delegate = self
        
        
        self.tabBar.backgroundColor = .BG
        self.tabBar.tintColor = .primary
        self.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.3)
        tabBar.layer.cornerRadius = 20
        
        
        
        let personVC = ProfileViewController()
        let twoTabItem = UITabBarItem(title: "", image: .person.resize(targetSize: CGSize(width: 20, height: 21)), tag: 1)
//        twoTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
//        twoTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        personVC.tabBarItem = twoTabItem
        personVC.delegate = self
        
        let workoutVC = WorkoutViewController()
        let threeTabItem = UITabBarItem(title: "", image: .work.resize(targetSize: CGSize(width: 23, height: 23)), tag: 1)
//        threeTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
//        threeTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        workoutVC.tabBarItem = threeTabItem
        
        let achVC = AcivementsViewController()
        let fourTabItem = UITabBarItem(title: "", image: .cup.resize(targetSize: CGSize(width: 23, height: 23)), tag: 1)
//        fourTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
//        fourTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        achVC.tabBarItem = fourTabItem
        
        
        let setVC = SettingsViewController()
        let fiveTabItem = UITabBarItem(title: "", image: .gear.resize(targetSize: CGSize(width: 23, height: 23)), tag: 1)
//        fiveTabItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
//        fiveTabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        setVC.tabBarItem = fiveTabItem
        
        
        
        viewControllers = [workoutVC, achVC, statVC, personVC, setVC]
        selectedIndex = 2
        tabBar.selectionIndicatorImage = createSelectionIndicatorImage()
        
    }
    
    
    func createSelectionIndicatorImage() -> UIImage? {
        // Размеры индикатора и отступ
        let dotSize = CGSize(width: 6, height: 6)
        let topPadding: CGFloat = 43
        let totalSize = CGSize(width: dotSize.width, height: dotSize.height + topPadding)
        
        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: totalSize.width, height: topPadding))
        
        let dotRect = CGRect(x: 0, y: topPadding, width: dotSize.width, height: dotSize.height)
        context.setFillColor(UIColor.primary.cgColor)
        context.fillEllipse(in: dotRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
                    // Предполагаем, что i.date хранит дату в формате Date
                    let dateComponents = calendar.dateComponents([.year, .month, .day], from: i.dete)
                    let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                    
                    if dateComponents.year == todayComponents.year &&
                        dateComponents.month == todayComponents.month &&
                        dateComponents.day == todayComponents.day {
                        kcalToday += i.calories
                    }
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


extension TabBarViewController: TabBarViewControllerDelegate {
    func openVC(index: Int) {
        selectedIndex = index
    }   
}
