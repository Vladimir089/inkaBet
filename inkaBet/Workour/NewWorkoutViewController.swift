//
//  NewWorkoutViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 04.07.2024.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    weak var delegate: WorkoutViewControllerDelegate?
    var saveButton: UIButton?
    var nameTextField, timeTextField, appTextFielf, repTextField, calTextField: UITextField?
    var datePicker: UIDatePicker?
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        createInterface()
        //clearUserDefaults()
    }
    
    deinit {
        delegate?.closed()
    }
    
    func clearUserDefaults() {
        let defaults = UserDefaults.standard
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
        }
        defaults.synchronize()
    }
    

    func createInterface() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        
        let hideView: UIView = {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.1)
            view.layer.cornerRadius = 2.5
            return view
        }()
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        let createLabel: UILabel = {
            let label = UILabel()
            label.text = "Create workout"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1)
            return label
        }()
        view.addSubview(createLabel)
        createLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-20)
        }
        
        
        nameTextField = createTextField(text: "Name")
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(createLabel.snp.bottom).inset(-30)
        })
        
        timeTextField = createTextField(text: "Time")
        timeTextField?.keyboardType = .numberPad
        view.addSubview(timeTextField!)
        timeTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        })
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Создаем UIToolbar с кнопкой Done
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        // Устанавливаем UIDatePicker как inputView для timeTextField
        timeTextField?.inputView = datePicker!
        timeTextField?.inputAccessoryView = toolbar
        
        
        appTextFielf = createTextField(text: "Approaches")
        appTextFielf?.keyboardType = .numberPad
        view.addSubview(appTextFielf!)
        appTextFielf?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(timeTextField!.snp.bottom).inset(-15)
        })
        
        repTextField  = createTextField(text: "Repetitions")
        repTextField?.keyboardType = .numberPad
        view.addSubview(repTextField!)
        repTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(appTextFielf!.snp.bottom).inset(-15)
        })
        
        calTextField  = createTextField(text: "Calories burned")
        calTextField?.keyboardType = .numberPad
        view.addSubview(calTextField!)
        calTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(repTextField!.snp.bottom).inset(-15)
        })
        
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.BG, for: .normal)
            button.setTitleColor(.BG.withAlphaComponent(0.5), for: .disabled)
            button.backgroundColor = .primary
            button.layer.cornerRadius = 16
            button.isEnabled = false
            return button
        }()
        saveButton?.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(63)
        })
        
    }
    
    @objc func saveData() {
        let work = Workout(
            name: nameTextField?.text ?? "",
            time: timeTextField?.text ?? "",
            approaches: Int(appTextFielf?.text ?? "1") ?? 1,
            repetitions: Int(repTextField?.text ?? "1") ?? 1,
            calories: CGFloat(Int(calTextField?.text ?? "1") ?? 1),
            dete: Date()
        )
        
        workArr.append(work)
        checkAchivements()
        

        if let encoded = try? JSONEncoder().encode(workArr) {
            UserDefaults.standard.setValue(encoded, forKey: "work")
        }
        
        self.dismiss(animated: true)
    }
    
    
    func checkAchivements() {
        if workArr.count >= 1 {
            achivementArr[0] = true
        }
        if workArr.count >= 5 {
            achivementArr[1] = true
        }
        if workArr.count >= 10 {
            achivementArr[2] = true
        }
        if workArr.count >= 15 {
            achivementArr[3] = true
        }
        if workArr.count >= 20 {
            achivementArr[4] = true
        }
        if workArr.count >= 25 {
            achivementArr[5] = true
        }
        
        
        var totalHours = 0
        
        for i in workArr {
            let hoursString = String(i.time.prefix(2))
            if let hours = Int(hoursString) {
                totalHours += hours
            }
        }
        print(totalHours, "часы")
        if totalHours > 40 {
            achivementArr[6] = true
        }
        
        
        
        UserDefaults.standard.setValue(achivementArr, forKey: "ach")
        
        
    }
    
    
    
    
    
    
    @objc func hideKeyboard() {
        check()
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        check()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTextField?.text = formatter.string(from: datePicker?.date ?? Date())
    }
    
    @objc func donePressed() {
        check()
        self.view.endEditing(true)
    }
    
    
    
    
    func createTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 22/255, green: 23/255, blue: 28/255, alpha: 1)
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        textField.rightViewMode = .always
        textField.textColor = .white
        textField.layer.cornerRadius = 12
        textField.textAlignment = .right
        textField.delegate = self
        
        let label = UILabel()
        label.text = "    \(text) "
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.4)
        textField.leftView = label
        textField.leftViewMode = .always
        return textField
    }
    
    
    func check() {
        if nameTextField?.text != "" && timeTextField?.text != ""  && appTextFielf?.text != "" && repTextField?.text != "", calTextField?.text != "" {
            saveButton?.isEnabled = true
        } else {
            saveButton?.isEnabled = false
        }
    }

}



extension NewWorkoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        check()
        return true
    }
}
