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
    
    var achLabel: UILabel?
    
    var ageLabel, weightLabel, heightLabel, normLabel: UILabel?
    
    var collection: UICollectionView?
    
    weak var delegate: TabBarViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            imageView.backgroundColor = .bgSecond
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
        
        let labelAch: UILabel = {
            let label = UILabel()
            label.text = "ACHIEVEMENTS"
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.textColor = UIColor(red: 144/255, green: 152/255, blue: 163/255, alpha: 1)
            return label
        }()
        view.addSubview(labelAch)
        labelAch.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(stackViewTwo.snp.bottom).inset(-20)
        }
        
        achLabel = {
            let label = UILabel()
            
            var achivementCompleted = 0
            for i in achivementArr {
                if i == true {
                    achivementCompleted += 1
                }
            }
            
            label.text = "\(achivementCompleted)/7"
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.textColor = UIColor(red: 144/255, green: 152/255, blue: 163/255, alpha: 0.5)
            return label
        }()
        view.addSubview(achLabel!)
        achLabel?.snp.makeConstraints({ make in
            make.left.equalTo(labelAch.snp.right).inset(-5)
            make.top.equalTo(stackViewTwo.snp.bottom).inset(-20)
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .horizontal
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            collection.showsHorizontalScrollIndicator = false
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.height.equalTo(171)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelAch.snp.bottom).inset(-15)
        })
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openAch))
        collection?.addGestureRecognizer(gesture)
    }
    
    @objc func openAch() {
        delegate?.openVC(index: 1)
    }
    
    func updateView() {
        let image = UIImage(data: person?.image ?? Data()) ?? UIImage.standart
        imageProfileView?.image = image
        nameLabel?.text = person?.name ?? "Anonim"
        ageLabel?.text = "\(person?.age ?? 0)"
        weightLabel?.text = "\(person?.weight ?? 0)"
        heightLabel?.text = "\(person?.height ?? 0)"
        normLabel?.text = "\(person?.norm ?? 0) "
        
        
        var achivementCompleted = 0
        for i in achivementArr {
            if i == true {
                achivementCompleted += 1
            }
        }
        achLabel?.text = "\(achivementCompleted)/7"
        collection?.reloadData()
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


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .BG
        cell.layer.cornerRadius = 24
        
        
        let image = imageArr[indexPath.row].resize(targetSize: CGSize(width: 82, height: 82))
        var imageView = UIImageView(image: image)
        
        
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(82)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        
        if achivementArr[indexPath.row] == false {
            if let grayImage = applyGrayFilter(to: image) {
                imageView.image = grayImage
            }
        }

        
        
        
        let label = UILabel()
        label.text = textAchivArr[indexPath.row]
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 171)
    }
    
    func applyGrayFilter(to image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIPhotoEffectMono") {
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            if let output = currentFilter.outputImage,
               let cgimg = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
    
    
}
