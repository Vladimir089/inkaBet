//
//  newAndEditPlanViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 12.07.2024.
//

import UIKit

class newAndEditPlanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: PlanViewControllerDelegate?
    weak var secondDelegate: DetailPlanViewControllerDelegate?
    var isNew = true
    var index = 0
    
    
    var execurseArr = [Execurse]()
    var collection: UICollectionView?
    
    //ui
    var imageView: UIImageView?
    var nameTextField: UITextField?
    var indexExecurse = 0
    var isEditingExecurse = false
    
    
    var labelAdd: UILabel?
    var saveNewExecurseButton: UIButton?
    
    //editPlan
    var newPlanView: UIView?
    var newPlanImageView: UIImageView?
    var newPlanNameTextField: UITextField?
    var newPlanExplanationTextField: UITextField?
    
    //other
    var currentImageView: UIImageView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        delegate?.reloadTable()
        secondDelegate?.reloadComponents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BG
        settingsInterface()
        checkIsNew()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
    
    func settingsInterface() {
        let hideView = UIView()
        hideView.backgroundColor = .white.withAlphaComponent(0.1)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        let label = UILabel()
        
        if isNew == true {
            label.text = "New"
        } else {
            label.text = "Edit"
        }

        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        
        imageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .bgSecond
            imageView.layer.cornerRadius = 12
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            imageView.tag = 1
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.height.equalTo(176)
            make.width.equalTo(192)
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).inset(-20)
        })
        let gestureImageView = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gestureImageView)
        
        var textFieldView = UIView()
        textFieldView.backgroundColor = .bgSecond
        textFieldView.layer.cornerRadius = 12
        view.addSubview(textFieldView)
        textFieldView.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.right.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-20)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
        nameLabel.textColor = .white.withAlphaComponent(0.4)
        textFieldView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        
        nameTextField = {
            let textField = UITextField()
            textField.borderStyle = .none
            textField.layer.cornerRadius = 12
            textField.delegate = self
            textField.placeholder = "Text"
            textField.textAlignment = .right
            textField.textColor = .white
            return textField
        }()
        textFieldView.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(nameLabel.snp.right).inset(-15)
            make.centerY.equalToSuperview()
        })
        
        
        
//        let gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        view.addGestureRecognizer(gestureHideKeyboard)
        
        
        let addButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 29
            let image = UIImage.plus.resize(targetSize: CGSize(width: 23, height: 30))
            button.setImage(image, for: .normal)
            button.setTitleColor(UIColor(red: 31/255, green: 32/255, blue: 41/255, alpha: 1), for: .normal)
            button.backgroundColor = .primary
            return button
        }()
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(58)
            make.centerX.equalToSuperview()
            make.top.equalTo(textFieldView.snp.bottom).inset(-15)
        }
        addButton.addTarget(self, action: #selector(showNewPlan), for: .touchUpInside)
        
        newPlanView = {
            let view = UIView()
            view.alpha = 0
            view.backgroundColor = .BG
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            view.layer.cornerRadius = 20
            
            labelAdd = UILabel()
            labelAdd?.text = "Add"
            labelAdd?.font = .systemFont(ofSize: 22, weight: .semibold)
            labelAdd?.textColor = .white
            view.addSubview(labelAdd!)
            labelAdd?.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(15)
            }
            
            newPlanImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage.imageOlan.resize(targetSize: CGSize(width: 30, height: 30))
                imageView.contentMode = .center
                imageView.backgroundColor = .bgSecond
                imageView.layer.cornerRadius = 12
                imageView.isUserInteractionEnabled = true
                imageView.clipsToBounds = true
                imageView.tag = 2
                return imageView
            }()
            view.addSubview(newPlanImageView!)
            newPlanImageView?.snp.makeConstraints({ make in
                make.height.equalTo(176)
                make.width.equalTo(192)
                make.centerX.equalToSuperview()
                make.top.equalTo(labelAdd!.snp.bottom).inset(-15)
            })
            
            let gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(gestureHideKeyboard)
            let gestureImageView = UITapGestureRecognizer(target: self, action: #selector(setImageNew))
            newPlanImageView?.addGestureRecognizer(gestureImageView)
            
            
            let nameView = UIView()
            nameView.backgroundColor = .bgSecond
            nameView.layer.cornerRadius = 12
            view.addSubview(nameView)
            nameView.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(newPlanImageView!.snp.bottom).inset(-15)
            }
            let nameLabel = UILabel()
            nameLabel.text = "Name"
            nameLabel.textAlignment = .left
            nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
            nameLabel.textColor = .white.withAlphaComponent(0.4)
            nameView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(60)
            }
            
            newPlanNameTextField = {
                let textField = UITextField()
                textField.borderStyle = .none
                textField.textColor = .white
                textField.placeholder = "Text"
                textField.delegate  = self
                textField.textAlignment = .right
                return textField
            }()
            nameView.addSubview(newPlanNameTextField!)
            newPlanNameTextField?.snp.makeConstraints({ make in
                make.left.equalTo(nameLabel.snp.right).inset(-5)
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            })
            
            
            
            let explanationView = UIView()
            explanationView.backgroundColor = .bgSecond
            explanationView.layer.cornerRadius = 12
            view.addSubview(explanationView)
            explanationView.snp.makeConstraints { make in
                make.height.equalTo(54)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(nameView.snp.bottom).inset(-15)
            }
            let explantationLabel = UILabel()
            explantationLabel.text = "Explanation"
            explantationLabel.textAlignment = .left
            explantationLabel.font = .systemFont(ofSize: 17, weight: .regular)
            explantationLabel.textColor = .white.withAlphaComponent(0.4)
            explanationView.addSubview(explantationLabel)
            explantationLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(90)
            }
            
            newPlanExplanationTextField = {
                let textField = UITextField()
                textField.borderStyle = .none
                textField.textColor = .white
                textField.placeholder = "Text"
                textField.delegate  = self
                textField.textAlignment = .right
                return textField
            }()
            explanationView.addSubview(newPlanExplanationTextField!)
            newPlanExplanationTextField?.snp.makeConstraints({ make in
                make.left.equalTo(explantationLabel.snp.right).inset(-5)
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            })
            
            let closeBut: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("Close", for: .normal)
                button.backgroundColor = .clear
                button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
                button.setTitleColor(.primary, for: .normal)
                button.layer.borderColor = UIColor.primary.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 16
                return button
            }()
            view.addSubview(closeBut)
            closeBut.snp.makeConstraints { make in
                make.height.equalTo(63)
                make.top.equalTo(explanationView.snp.bottom).inset(-15)
                make.left.equalToSuperview().inset(15)
                make.right.equalTo(view.snp.centerX).offset(-7.5)
            }
            closeBut.addTarget(self, action: #selector(closeNewEditView), for: .touchUpInside)
            
            
            saveNewExecurseButton = {
                let button = UIButton(type: .system)
                button.isEnabled = false
                button.setTitle("Save", for: .normal)
                button.backgroundColor = .primary
                button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = 16
                button.alpha = 0.5
                return button
            }()
            view.addSubview(saveNewExecurseButton!)
            saveNewExecurseButton?.snp.makeConstraints { make in
                make.height.equalTo(63)
                make.top.equalTo(explanationView.snp.bottom).inset(-15)
                make.right.equalToSuperview().inset(15)
                make.left.equalTo(view.snp.centerX).offset(7.5)
            }
            
            saveNewExecurseButton?.addTarget(self, action: #selector(saveExecusion), for: .touchUpInside)
            
            return view
        }()
        
        
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.layer.cornerRadius = 12
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "main")
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            collection.isUserInteractionEnabled = true
            return collection
        }()
        
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(addButton.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        })
        
        
        let closeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Delete", for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.primary, for: .normal)
            button.layer.borderColor = UIColor.primary.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 16
            return button
        }()
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(63)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
        }
        closeButton.addTarget(self, action: #selector(del), for: .touchUpInside)
        
        var saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.backgroundColor = .primary
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 16
            return button
        }()
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(63)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        }
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        
        
        view.addSubview(newPlanView!)
        newPlanView?.snp.makeConstraints({ make in
            make.height.equalTo(460)
            make.left.right.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        })
    }
    
    @objc func save() {

        let plan = Plan(image: imageView?.image?.jpegData(compressionQuality: 0.5) ?? Data(), name: nameTextField?.text ?? "", execurse: execurseArr)
        
        if isNew == true {
            planArr.append(plan)
        } else {
            planArr[index] = plan
        }
        
        
        
         do {
             let data = try JSONEncoder().encode(planArr) //тут мкассив конвертируем в дату
             try saveAthleteArrToFile(data: data)
             self.dismiss(animated: true)
         } catch {
             print("Failed to encode or save athleteArr: \(error)")
         }
        
        
    }
    
    @objc func del() {
        secondDelegate?.delIndex()
        self.dismiss(animated: true)
    }
    
    

    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("Plan.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   
    
    
    
    
    
    
    
    @objc func saveExecusion() {
        
        let new = Execurse(image: newPlanImageView?.image?.jpegData(compressionQuality: 0.5) ?? Data(), name: newPlanNameTextField?.text ?? "", explanation: newPlanExplanationTextField?.text ?? "")
        
        if isEditingExecurse == true {
            execurseArr[indexExecurse] = new
        } else {
            execurseArr.append(new)
        }

        
        closeNewEditView()
        collection?.reloadData()
    }
    
    func checkSaveButton() {
        if newPlanNameTextField?.text?.count ?? 0 > 0, newPlanExplanationTextField?.text?.count ?? 0 > 0 {
            saveNewExecurseButton?.isEnabled = true
            saveNewExecurseButton?.alpha = 1
        } else {
            saveNewExecurseButton?.isEnabled = false
            saveNewExecurseButton?.alpha = 0.5
        }
    }
    
    
    @objc func closeNewEditView() {
        
        UIView.animate(withDuration: 0.3) {
            self.newPlanView?.alpha = 0
        }
        
        isEditingExecurse = false
        saveNewExecurseButton?.isEnabled = false
        saveNewExecurseButton?.alpha = 0.5
        newPlanNameTextField?.text = ""
        newPlanExplanationTextField?.text = ""
        newPlanImageView?.image = UIImage.imageOlan.resize(targetSize: CGSize(width: 30, height: 30))
        newPlanImageView?.contentMode = .center
    }
    
    @objc func showNewPlan() {
        
        print(isEditingExecurse)
        
        if isEditingExecurse == false {
            labelAdd?.text = "Add"
            newPlanNameTextField?.text = ""
            newPlanExplanationTextField?.text = ""
            newPlanImageView?.image = UIImage.imageOlan.resize(targetSize: CGSize(width: 30, height: 30))
            newPlanImageView?.contentMode = .center
            saveNewExecurseButton?.isEnabled = false
            saveNewExecurseButton?.alpha = 0.5
            isEditingExecurse = false
        }
        
        if isEditingExecurse == true {
            labelAdd?.text = "Edit"
            newPlanNameTextField?.text = execurseArr[indexExecurse].name
            newPlanExplanationTextField?.text = execurseArr[indexExecurse].explanation
            newPlanImageView?.image = UIImage(data: execurseArr[indexExecurse].image)
            newPlanImageView?.contentMode = .scaleAspectFill
            checkSaveButton()
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.newPlanView?.alpha = 1
        }
 
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func setImage() {
        currentImageView = imageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate methods
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           if let pickedImage = info[.originalImage] as? UIImage {
               currentImageView?.image = pickedImage
               currentImageView?.contentMode = .scaleAspectFill
           }
       }
    
    @objc func setImageNew() {
        currentImageView = newPlanImageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
  
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkIsNew() {
        if isNew == true {
            imageView?.image = UIImage.imageOlan.resize(targetSize: CGSize(width: 30, height: 30))
            imageView?.contentMode = .center
        } else {
            imageView?.image = UIImage(data: planArr[index].image)
            imageView?.contentMode = .scaleAspectFill
            nameTextField?.text = planArr[index].name
            execurseArr = planArr[index].execurse
            collection?.reloadData()
        }
    }

   

}


extension newAndEditPlanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkSaveButton()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkSaveButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSaveButton()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkSaveButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSaveButton()
        return true
    }
}


extension newAndEditPlanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return execurseArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .bgSecond
        cell.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: UIImage(data: execurseArr[indexPath.row].image))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let labelName = UILabel()
        labelName.text = execurseArr[indexPath.row].name
        labelName.font = .systemFont(ofSize: 17, weight: .semibold)
        labelName.textColor = .white
        cell.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.bottom.equalTo(cell.snp.centerY).offset(-4)
        }
        
        let labelDetail = UILabel()
        labelDetail.font = .systemFont(ofSize: 16, weight: .semibold)
        labelDetail.textColor = .white.withAlphaComponent(0.4)
        labelDetail.text = execurseArr[indexPath.row].explanation
        cell.addSubview(labelDetail)
        labelDetail.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.top.equalTo(cell.snp.centerY).offset(4)
        }
        
        let imageViewPencil = UIImageView(image: .pencil)
        imageViewPencil.contentMode = .scaleAspectFit
        cell.addSubview(imageViewPencil)
        imageViewPencil.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexExecurse = indexPath.row
        isEditingExecurse = true
        showNewPlan()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
    
}
