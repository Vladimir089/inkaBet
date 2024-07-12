//
//  DetailPlanViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 13.07.2024.
//

import UIKit
 
protocol DetailPlanViewControllerDelegate: AnyObject {
    func reloadComponents()
    func delIndex()
}

class DetailPlanViewController: UIViewController {
    
    var index = 0
    var imageView: UIImageView?
    var collection: UICollectionView?
    var nameLabel: UILabel?
    var delete = false
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegateMain?.reloadPlans()
        delegateSecond?.reloadTable()
        
    }
    
    weak var delegateMain: WorkoutViewControllerDelegate?
    weak var delegateSecond: PlanViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        createInterface()
    }
    

    func createInterface() {
        
        imageView = UIImageView(image: UIImage(data: planArr[index].image))
        imageView?.contentMode = .scaleAspectFill
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.top.leading.right.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        })
        
        let secondView: UIView = {
            let view = UIView()
            view.backgroundColor = .BG
            view.layer.cornerRadius = 20
            return view
        }()
        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(-20)
        }
        
        nameLabel = UILabel()
        nameLabel?.text = planArr[index].name
        nameLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        nameLabel?.textColor = .white
        secondView.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
        }
        
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "main")
            collection.backgroundColor = .clear
            collection.layer.cornerRadius = 12
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        secondView.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(nameLabel!.snp.bottom).inset(-15)
        })
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
        }
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
    }
    
    @objc func edit() {
        let vc = newAndEditPlanViewController()
        vc.index = index
        vc.isNew = false
        vc.secondDelegate = self
        self.present(vc, animated: true)
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

}


extension DetailPlanViewController: DetailPlanViewControllerDelegate {
    
    func delIndex() {
        delete = true
        if planArr.count >= index {
            planArr.remove(at: index)
            
            do {
                let data = try JSONEncoder().encode(planArr) //тут мкассив конвертируем в дату
                try saveAthleteArrToFile(data: data)
                self.dismiss(animated: true)
            } catch {
                print("Failed to encode or save athleteArr: \(error)")
            }
            self.dismiss(animated: true)
        }
    }
    
    func reloadComponents() {
        if delete == false {
            imageView?.image = UIImage(data: planArr[index].image)
            nameLabel?.text = planArr[index].name
            collection?.reloadData()
        }
    }
    
    
}



extension DetailPlanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planArr[index].execurse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .bgSecond
        cell.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: UIImage(data: planArr[index].execurse[indexPath.row].image))
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
        labelName.text = planArr[index].execurse[indexPath.row].name
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
        labelDetail.text = planArr[index].execurse[indexPath.row].explanation
        cell.addSubview(labelDetail)
        labelDetail.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.top.equalTo(cell.snp.centerY).offset(4)
        }
        
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
   
    
    
}
