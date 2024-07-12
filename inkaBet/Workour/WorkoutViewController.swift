//
//  WorkoutViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 04.07.2024.
//

import UIKit

var planArr = [Plan]()

protocol WorkoutViewControllerDelegate: AnyObject {
    func closed()
    func reloadPlans()
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
    
    //new
    var noTraningView: UIView?
    var collectiomPlans: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
        checkArr()
        
        planArr =  loadAthleteArrFromFile() ?? [Plan]()
        checkPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkArr()
    }
    
    
    //ЗАГРУЗКА С ФАЙЛА
       func loadAthleteArrFromFile() -> [Plan]? {
           let fileManager = FileManager.default
           guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
               print("Unable to get document directory")
               return nil
           }
           let filePath = documentDirectory.appendingPathComponent("Plan.plist")
           do {
               let data = try Data(contentsOf: filePath)
               let athleteArr = try JSONDecoder().decode([Plan].self, from: data)
               return athleteArr
           } catch {
               print("Failed to load or decode athleteArr: \(error)")
               return nil
           }
       }
    
    func checkPlans() {
        if planArr.count > 0 {
            collectiomPlans?.alpha = 1
            noTraningView?.alpha = 0
        } else {
            collectiomPlans?.alpha = 0
            noTraningView?.alpha = 1
        }
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
            make.top.equalTo(labelStat.snp.bottom)
        }
        createButton.addTarget(self, action: #selector(createWork), for: .touchUpInside)
        
        
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
            make.right.equalTo(createButton.snp.left).inset(-15)
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(createButton)
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
        
        noTraningView = {
            let view = UIView()
            view.backgroundColor = .BG
            view.layer.cornerRadius = 16
            
            let imageView = UIImageView(image: .zeus)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(35)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-15)
            }
            
            let noRecordsLabel = UILabel()
            noRecordsLabel.text = "There are no records"
            noRecordsLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            noRecordsLabel.textColor = .white
            view.addSubview(noRecordsLabel)
            noRecordsLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).inset(-5)
            }
            
            return view
        }()
        view.addSubview(noTraningView!)
        noTraningView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.height.equalTo(162)
        })
        
        
        
        collectiomPlans = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "plan")
            collection.backgroundColor = .clear
            collection.layer.cornerRadius = 12
            collection.delegate = self
            collection.dataSource = self
            collection.showsHorizontalScrollIndicator = false
            return collection
        }()
        view.addSubview(collectiomPlans!)
        collectiomPlans?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.height.equalTo(162)
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
            collection.layer.cornerRadius = 16
            return collection
        }()
        view.addSubview(collectiom!)
        collectiom?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(segmented!.snp.bottom).inset(-15)
            make.bottom.equalTo(noTraningView!.snp.top).inset(-50)
        })
        
        
        
        
        let labelPlan = UILabel()
        labelPlan.text = "Training"
        labelPlan.textColor = .white
        labelPlan.font = .systemFont(ofSize: 22, weight: .semibold)
        view.addSubview(labelPlan)
        labelPlan.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(collectiom!.snp.bottom).inset(-15)
        }
        
        let allPlanButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("See All", for: .normal)
            button.setTitleColor(.primary, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            return button
        }()
        view.addSubview(allPlanButton)
        allPlanButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(labelPlan)
        }
        allPlanButton.addTarget(self, action: #selector(openPlans), for: .touchUpInside)
        
       
        checkArr()
    }
    
    @objc func openPlans() {
        let vc = PlanViewController()
        vc.delegate = self
        self.present(vc, animated: true)
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
        if collectionView != collectiomPlans {
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
        } else {
            return planArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (collectionView == collectiomPlans ? "plan": "cell"), for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .BG
        cell.layer.cornerRadius = 16
        
        if collectionView != collectiomPlans {
            
            
            
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
        } else {
            

 
            
            let imageView = UIImageView(image: UIImage(data: planArr[indexPath.row].image))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(130)
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            
            let nameLabel = UILabel()
            nameLabel.text = planArr[indexPath.row].name
            nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            nameLabel.textColor = .white
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).inset(-5)
                make.centerX.equalToSuperview()
            }
            
            
           
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != collectiomPlans {
            return CGSize(width: collectionView.frame.width, height: 110)
        } else {
            return CGSize(width: 130, height: collectionView.frame.height)
        }
        
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectiomPlans {
            let vc = DetailPlanViewController()
            vc.index = indexPath.row
            vc.delegateMain = self
            self.present(vc, animated: true)
        }
    }
    
}
  

extension WorkoutViewController: WorkoutViewControllerDelegate {
    
    func reloadPlans() {
        collectiomPlans?.reloadData()
        print(12)
    }
    
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
