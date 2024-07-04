//
//  WorkoutViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 04.07.2024.
//

import UIKit

protocol WorkoutViewControllerDelegate: AnyObject {
    func closed()
}

class WorkoutViewController: UIViewController {
    
    var segmented: UISegmentedControl?
    var selected = "Today"
    
    //ui
    var imageViewCenter: UIImageView?
    var collectiom: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
        checkArr()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkArr()
    }
    

    func createInterface() {
        
        let labelStat: UILabel = {
            let label = UILabel()
            label.text = "Workout"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        view.addSubview(labelStat)
        labelStat.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        segmented = {
            let segmented = UISegmentedControl(items: ["Today", "History"])
            segmented.selectedSegmentIndex = 0
            segmented.backgroundColor = .BG
            segmented.selectedSegmentTintColor = UIColor(red: 46/255, green: 47/255, blue: 61/255, alpha: 1)
            
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
            segmented.setTitleTextAttributes(titleTextAttributes, for: .selected)
            
            return segmented
        }()
        segmented?.addTarget(self, action: #selector(selectedChanged), for: .valueChanged)
    
        view.addSubview(segmented!)
        segmented?.snp.makeConstraints({ make in
            make.height.equalTo(32)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelStat.snp.bottom).inset(-15)
        })
        
        
        imageViewCenter = {
            let image = UIImage.center
            let imageView = UIImageView(image: image)
            imageView.alpha = 0
            return imageView
        }()
        view.addSubview(imageViewCenter!)
        imageViewCenter?.snp.makeConstraints({ make in
            make.height.equalTo(333)
            make.width.equalTo(261)
            make.centerY.centerX.equalToSuperview()
        })
        
        
        collectiom = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collectiom!)
        collectiom?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(segmented!.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        })
        
        let createButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 29
            let image = UIImage.plus.resize(targetSize: CGSize(width: 23, height: 30))
            button.setImage(image, for: .normal)
            button.setTitleColor(UIColor(red: 31/255, green: 32/255, blue: 41/255, alpha: 1), for: .normal)
            button.backgroundColor = .primary
            return button
        }()
        
        view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.height.width.equalTo(58)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
        createButton.addTarget(self, action: #selector(createWork), for: .touchUpInside)
        
        checkArr()
    }
    
    
    func checkArr() {
        if workArr.count == 0 {
            imageViewCenter?.alpha = 1
        } else {
            imageViewCenter?.alpha = 0
        }
        collectiom?.reloadData()
    }
    
    
    
    @objc func selectedChanged() {
        if selected == "Today" {
            selected = "History"
        } else {
            selected = "Today"
        }
        collectiom?.reloadData()
    }
    
    @objc func createWork() {
        let vc = NewWorkoutViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    
    
    

}


extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .red
        return cell
    }
    
    
}
  

extension WorkoutViewController: WorkoutViewControllerDelegate {
    func closed() {
        checkArr()
        selectedChanged()
        
        kcalToday = 0
        for i in workArr {
            kcalToday += i.calories
        }
        
    }
}
