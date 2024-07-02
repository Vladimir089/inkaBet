//
//  NewUserViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit

class NewUserViewController: UIViewController {
    
    var avatarImageView: UIImageView?
    var nameTextField, weightTextField, heightTextField, normTextField, ageTextField: UITextField?
    var saveButton: UIButton?
    
    var delegate: OnboardingContentViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            self.check()
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
            self.check()
        }
    }
    

    func createInterface() {
        view.backgroundColor = .BG
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
            label.text = "Create profile"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = UIColor(red: 242/255, green: 242/255, blue: 246/255, alpha: 1)
            return label
        }()
        view.addSubview(createLabel)
        createLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-20)
        }
        
        avatarImageView = {
            let image = UIImage.standart
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.backgroundColor = .bgSecond
            imageView.layer.cornerRadius = 45
            return imageView
        }()
        view.addSubview(avatarImageView!)
        avatarImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalTo(createLabel.snp.bottom).inset(-35)
        })
        
        let enterPhotoButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(.edit.resize(targetSize: CGSize(width: 28, height: 22)), for: .normal)
            button.backgroundColor = .BG
            button.layer.cornerRadius = 15
            button.tintColor = .primary
            return button
        }()
        enterPhotoButton.addTarget(self, action: #selector(changePhoto), for: .touchUpInside)
        view.addSubview(enterPhotoButton)
        enterPhotoButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.left.equalTo(avatarImageView!.snp.right).inset(23)
            make.top.equalTo(avatarImageView!.snp.top).inset(5)
        }
        
        nameTextField = createTextField(text: "Name")
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(avatarImageView!.snp.bottom).inset(-35)
        })
        
        weightTextField = createTextField(text: "Weight (Kg)")
        weightTextField?.keyboardType = .numberPad
        view.addSubview(weightTextField!)
        weightTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-10)
        })
        
        heightTextField = createTextField(text: "Height")
        heightTextField?.keyboardType = .numberPad
        view.addSubview(heightTextField!)
        heightTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(weightTextField!.snp.bottom).inset(-10)
        })
        
        normTextField = createTextField(text: "Daily norm (Kkal)")
        normTextField?.keyboardType = .numberPad
        view.addSubview(normTextField!)
        normTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(heightTextField!.snp.bottom).inset(-10)
        })
        
        ageTextField = createTextField(text: "Full years")
        ageTextField?.keyboardType = .numberPad
        view.addSubview(ageTextField!)
        ageTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(normTextField!.snp.bottom).inset(-10)
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func changePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func check() {
        if nameTextField?.text != "" && weightTextField?.text != ""  && heightTextField?.text != "" && normTextField?.text != "", ageTextField?.text != "" {
            saveButton?.isEnabled = true
        } else {
            saveButton?.isEnabled = false
        }
    }
    
    @objc func saveData() {
        guard let name = nameTextField?.text,
              let weightText = weightTextField?.text, let weight = Int(weightText),
              let heightText = heightTextField?.text, let height = Int(heightText),
              let normText = normTextField?.text, let norm = Int(normText),
              let ageText = ageTextField?.text, let age = Int(ageText),
              let avatarImage = avatarImageView?.image,
              let imageData = avatarImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let user = User(name: name, weight: weight, height: height, norm: norm, image: imageData, age: age)
        person = user
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: "userProfile")
            self.dismiss(animated: true)
            delegate?.saved()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    

}



extension NewUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        check()
        return true
    }
}

extension NewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               let resizedImage = resizeImage(image: selectedImage, targetSize: CGSize(width: selectedImage.size.width * 0.3, height: selectedImage.size.height * 0.3))
               avatarImageView?.image = resizedImage
           }
           dismiss(animated: true, completion: nil)
        check()
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
           check()
       }
       
       // MARK: - Image Resizing Method
       
       func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
           let size = image.size
           
           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height
           
           // Determine what scale factor to use (the smallest one)
           let scaleFactor = min(widthRatio, heightRatio)
           
           // Compute the new image size that preserves the original aspect ratio
           let scaledImageSize = CGSize(
               width: size.width * scaleFactor,
               height: size.height * scaleFactor
           )
           
           // Draw and resize the image
           let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
           let resizedImage = renderer.image { (context) in
               image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
           }
           check()
           return resizedImage
       }
}
