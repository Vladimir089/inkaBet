//
//  StatisticsViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//



import UIKit

protocol StatisticsViewControllerDelegate: AnyObject {
    func openWater()
    func openSteps()
}

class StatisticsViewController: UIViewController {
    
    var mainView: StatView?
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView?.updateProgress()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = StatView()
        mainView?.delegate = self
        self.view = mainView
        loadDataWaterAndSteps()
        print(person)
    }
    

    
    func loadDataWaterAndSteps() {
        if UserDefaults.standard.object(forKey: "waterCount") != nil &&  UserDefaults.standard.object(forKey: "waterRequired") != nil {
            let count = UserDefaults.standard.object(forKey: "waterCount") as? Float
            let reqired = UserDefaults.standard.object(forKey: "waterRequired") as? Float
            mainView?.waterRequired = reqired
            mainView?.waterCount = count
            mainView?.waterLabel?.text = "\(Int(count ?? 0))/\(Int(reqired ?? 0))"
            mainView?.waterProgress?.setProgress(Float((count ?? 0)/(reqired ?? 0)), animated: true)
        }
        
        if UserDefaults.standard.object(forKey: "stepCount") != nil &&  UserDefaults.standard.object(forKey: "stepRequired") != nil {
            let count = UserDefaults.standard.object(forKey: "stepCount") as? Float
            let reqired = UserDefaults.standard.object(forKey: "stepRequired") as? Float
            mainView?.stepRequired = reqired
            mainView?.stepCount = count
            mainView?.stepLabel?.text = "\(Int(count ?? 0))/\(Int(reqired ?? 0))"
            mainView?.stepProgress?.setProgress(Float((count ?? 0)/(reqired ?? 0)), animated: true)
        }
    }
    
    
    func saveWater(count: Float, Required: Float) {
        mainView?.waterRequired = Required
        mainView?.waterCount = count
        mainView?.waterLabel?.text = "\(Int(count))/\(Int(Required))"
        mainView?.waterProgress?.setProgress(Float(count/Required), animated: true)
        UserDefaults.standard.setValue(count, forKey: "waterCount")
        UserDefaults.standard.setValue(Required, forKey: "waterRequired")
    }
    
    func saveSteps(count: Float, Required: Float) {
        mainView?.stepRequired = Required
        mainView?.stepCount = count
        mainView?.stepLabel?.text = "\(Int(count))/\(Int(Required))"
        mainView?.stepProgress?.setProgress(Float(count/Required), animated: true)
        UserDefaults.standard.setValue(count, forKey: "stepCount")
        UserDefaults.standard.setValue(Required, forKey: "stepRequired")
    }

}

extension StatisticsViewController: StatisticsViewControllerDelegate {
    func openWater() {
        let alertController = UIAlertController(title: "Water", message: nil, preferredStyle: .alert)
        
        // Добавление первого текстового поля
        alertController.addTextField { [self] textField in
            textField.placeholder = "Your limit"
            textField.keyboardType = .numberPad
            if self.mainView?.waterRequired != nil {
                textField.text = mainView?.waterRequired as? String
            }
        }
        
        // Добавление второго текстового поля
        alertController.addTextField { textField in
            textField.placeholder = "Completed"
            textField.keyboardType = .numberPad
        }
        
        // Кнопка Cancel
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Кнопка Save
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alertController.textFields,
                  let waterCountText = textFields[1].text, let waterCount = Float(waterCountText),
                  let waterRequiredText = textFields[0].text, let waterRequired = Float(waterRequiredText) else {
                return
            }
            
            // Действие при нажатии на кнопку Save
            self.saveWater(count: waterCount, Required: waterRequired)
        }
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func openSteps() {
        let alertController = UIAlertController(title: "Steps", message: nil, preferredStyle: .alert)
        
        // Добавление первого текстового поля
        alertController.addTextField { [self] textField in
            textField.placeholder = "Your limit"
            textField.keyboardType = .numberPad
            if self.mainView?.waterRequired != nil {
                textField.text = mainView?.waterRequired as? String
            }
        }
        
        // Добавление второго текстового поля
        alertController.addTextField { textField in
            textField.placeholder = "Completed"
            textField.keyboardType = .numberPad
        }
        
        // Кнопка Cancel
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Кнопка Save
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textFields = alertController.textFields,
                  let waterCountText = textFields[1].text, let waterCount = Float(waterCountText),
                  let waterRequiredText = textFields[0].text, let waterRequired = Float(waterRequiredText) else {
                return
            }
            
            // Действие при нажатии на кнопку Save
            self.saveSteps(count: waterCount, Required: waterRequired)
        }
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
