//
//  ProfileViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 03.07.2024.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func saved()
}

class ProfileViewController: UIViewController {
    
    var imageProfileView: UIImageView?
    var nameLabel: UILabel?
    
    var ageLabel, weightLabel, heightLabel, normLabel: UILabel?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
    }
    

    func createInterface() {
        let labelStat: UILabel = {
            let label = UILabel()
            label.text = "Profile"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        view.addSubview(labelStat)
        labelStat.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        imageProfileView = {
            let image = UIImage(data: person?.image ?? Data()) ?? UIImage.standart
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 45
            imageView.clipsToBounds = true
            return imageView
        }()
        view.addSubview(imageProfileView!)
        imageProfileView?.snp.makeConstraints({ make in
            make.height.width.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalTo(labelStat.snp.bottom).inset(-30)
        })
        
        nameLabel = {
            let label = UILabel()
            label.text = person?.name ?? "Anonim"
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .white
            return label
        }()
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageProfileView!.snp.bottom).inset(-15)
        })
        
        let editButton: UIButton = {
            let button = UIButton(type: .system)
            let image = UIImage.editProfile.withRenderingMode(.alwaysTemplate)
            button.setImage(image.resize(targetSize: CGSize(width: 13, height: 13)), for: .normal)
            
            button.setTitle("Edit", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            button.setTitleColor(.primary, for: .normal)
            button.tintColor = .primary
            return button
        }()
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(49)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(labelStat.snp.centerY)
        }
        editButton.addTarget(self, action: #selector(editPerosn), for: .touchUpInside)
        
        var stackViewOne: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 15
            stack.distribution = .fillEqually
            return stack
        }()
        view.addSubview(stackViewOne)
        stackViewOne.snp.makeConstraints { make in
            make.height.equalTo(86)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((nameLabel?.snp.bottom)!).inset(-30)
        }
        
        
        let oneView = createView(tag: 1)
        let twoView = createView(tag: 2)
        stackViewOne.addArrangedSubview(oneView)
        stackViewOne.addArrangedSubview(twoView)
        
        
        
        var stackViewTwo: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 15
            stack.distribution = .fillEqually
            return stack
        }()
        view.addSubview(stackViewTwo)
        stackViewTwo.snp.makeConstraints { make in
            make.height.equalTo(86)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(stackViewOne.snp.bottom).inset(-15)
        }
        let threeView = createView(tag: 3)
        let fourView = createView(tag: 4)
        stackViewTwo.addArrangedSubview(threeView)
        stackViewTwo.addArrangedSubview(fourView)
        
        
    }
    
    func updateView() {
        let image = UIImage(data: person?.image ?? Data()) ?? UIImage.standart
        imageProfileView?.image = image
        nameLabel?.text = person?.name ?? "Anonim"
        ageLabel?.text = "\(person?.age ?? 0)"
        weightLabel?.text = "\(person?.weight ?? 0)"
        heightLabel?.text = "\(person?.height ?? 0)"
        normLabel?.text = "\(person?.norm ?? 0) "
        
    }
    
    @objc func editPerosn() {
        let vc = EditUserViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    

    
    
    
}

extension ProfileViewController {
    
    func createView(tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .BG
        view.layer.cornerRadius = 24
        
        let imageView = UIImageView()
        
   
        
        let labelBot = UILabel()
        labelBot.font = .systemFont(ofSize: 14, weight: .semibold)
        labelBot.textColor = .white.withAlphaComponent(0.4)
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
       
        
        view.addSubview(labelBot)
        labelBot.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.top.equalTo(imageView.snp.centerY).offset(3)
        }
        
        
        switch tag {
        case 1:
            
            ageLabel = UILabel()
            ageLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            ageLabel?.textColor = .white
            ageLabel?.text = "\(person?.age ?? 0)"
            view.addSubview(ageLabel!)
            ageLabel?.snp.makeConstraints({ make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.bottom.equalTo(imageView.snp.centerY).offset(3)
            })
            
            
            imageView.image = .one
            labelBot.text = "Full years"
            
        case 2:
            
            weightLabel = UILabel()
            weightLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            weightLabel?.textColor = .white
            weightLabel?.text = "\(person?.weight ?? 0)"
            view.addSubview(weightLabel!)
            weightLabel?.snp.makeConstraints({ make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.bottom.equalTo(imageView.snp.centerY).offset(3)
            })
            
            
            imageView.image = .two
            labelBot.text = "Weight"
        case 3:
            heightLabel = UILabel()
            heightLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            heightLabel?.textColor = .white
            heightLabel?.text = "\(person?.height ?? 0)"
            view.addSubview(heightLabel!)
            heightLabel?.snp.makeConstraints({ make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.bottom.equalTo(imageView.snp.centerY).offset(3)
            })
            
            imageView.image = .three
            labelBot.text = "Height"
        case 4:
            normLabel = UILabel()
            normLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            normLabel?.textColor = .white
            normLabel?.text = "\(person?.norm ?? 0)"
            view.addSubview(normLabel!)
            normLabel?.snp.makeConstraints({ make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.bottom.equalTo(imageView.snp.centerY).offset(3)
            })
            
            
            let kcalLabel = UILabel()
            kcalLabel.text = "Kkal"
            kcalLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            kcalLabel.textColor = .white.withAlphaComponent(0.7)
            normLabel?.addSubview(kcalLabel)
            kcalLabel.snp.makeConstraints { make in
                make.left.equalTo(normLabel!.snp.right)
                make.bottom.equalToSuperview().inset(2)
            }
            
            imageView.image = .four
            labelBot.text = "Daily norm"
        default:
            break
        }
        
        return view
    }
    
}


extension ProfileViewController: ProfileViewControllerDelegate {
    func saved() {
        updateView()
    }
}
