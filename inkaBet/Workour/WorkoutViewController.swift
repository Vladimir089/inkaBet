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
    
    let calendar = Calendar.current
    let today = Date()
    
    var todArr: [Workout] = []
    
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
            collection.showsVerticalScrollIndicator = false
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
        
        if selected == "Today" {
            todArr.removeAll()
            for i in workArr {
                // Предполагаем, что i.date хранит дату в формате Date
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: i.dete)
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                
                if dateComponents.year == todayComponents.year &&
                    dateComponents.month == todayComponents.month &&
                    dateComponents.day == todayComponents.day {
                    todArr.append(i)
                }
            }
            
            return todArr.count
            
        } else {
            return workArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .BG
        cell.layer.cornerRadius = 16
        
        let labelName = UILabel()
        labelName.font = .systemFont(ofSize: 16, weight: .semibold)
        labelName.textColor = .white
        cell.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
        }
        
        
        let labelKal = UILabel()
        labelKal.font = .systemFont(ofSize: 16, weight: .semibold)
        labelKal.textColor = UIColor(red: 98/255, green: 101/255, blue: 148/255, alpha: 1)
        cell.addSubview(labelKal)
        labelKal.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
        }
        
        let separator = UIView()
        separator.backgroundColor = .white.withAlphaComponent(0.15)
        cell.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelKal.snp.bottom).inset(-15)
        }
        
        let imageViewRep: UIImageView = {
            let image: UIImage = .rep
            let imageView = UIImageView(image: image.resize(targetSize: CGSize(width: 22, height: 22)))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        cell.addSubview(imageViewRep)
        imageViewRep.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.bottom.left.equalToSuperview().inset(15)
        }
        
        let labelRep = UILabel()
        labelRep.font = .systemFont(ofSize: 17, weight: .semibold)
        labelRep.textColor = .white
        cell.addSubview(labelRep)
        labelRep.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.equalTo(imageViewRep.snp.right).inset(-5)
        }
        
        let imageViewPovtor: UIImageView = {
            let image: UIImage = .povtor
            let imageView = UIImageView(image: image.resize(targetSize: CGSize(width: 20, height: 20)))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        cell.addSubview(imageViewPovtor)
        imageViewPovtor.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview().offset(-15)
        }
        
        
        let labelPovt = UILabel()
        labelPovt.font = .systemFont(ofSize: 17, weight: .semibold)
        labelPovt.textColor = .white
        cell.addSubview(labelPovt)
        labelPovt.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.equalTo(imageViewPovtor.snp.right).inset(-5)
        }
        
        let timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        timeLabel.textColor = .white
        cell.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(15)
        }
        
        
        let imageViewClock: UIImageView = {
            let image: UIImage = .clock
            let imageView = UIImageView(image: image.resize(targetSize: CGSize(width: 20, height: 20)))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        cell.addSubview(imageViewClock)
        imageViewClock.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.bottom.equalToSuperview().inset(15)
            make.right.equalTo(timeLabel.snp.left).inset(-5)
        }
        
        
        if selected == "Today" {
            let sortedTodArr = todArr.sorted(by: { $0.dete > $1.dete })
            labelName.text = sortedTodArr[indexPath.row].name
            labelKal.text = "\(Int(sortedTodArr[indexPath.row].calories)) Kkal"
            labelRep.text = "\(sortedTodArr[indexPath.row].repetitions)"
            labelPovt.text = "\(sortedTodArr[indexPath.row].approaches)"
            timeLabel.text = sortedTodArr[indexPath.row].time
        } else {
            let sortedArr = workArr.sorted(by: { $0.dete > $1.dete })
            labelName.text = sortedArr[indexPath.row].name
            labelKal.text = "\(Int(sortedArr[indexPath.row].calories)) Kkal"
            labelRep.text = "\(sortedArr[indexPath.row].repetitions)"
            labelPovt.text = "\(sortedArr[indexPath.row].approaches)"
            timeLabel.text = sortedArr[indexPath.row].time
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
}
  

extension WorkoutViewController: WorkoutViewControllerDelegate {
    func closed() {
        checkArr()
        
        
        kcalToday = 0
        
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
        
    }
}
