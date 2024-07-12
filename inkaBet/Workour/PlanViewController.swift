//
//  PlanViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 12.07.2024.
//

import UIKit

protocol PlanViewControllerDelegate: AnyObject {
    func reloadTable()
}

class PlanViewController: UIViewController {
    
    weak var delegate: WorkoutViewControllerDelegate?
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BG
        createInerface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reloadPlans()
    }
    

    func createInerface() {
        
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
        label.text = "Training plan"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        let addButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Add", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            button.setTitleColor(.primary, for: .normal)
            return button
        }()
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(label)
        }
        addButton.addTarget(self, action: #selector(newPlan), for: .touchUpInside)
        
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
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(addButton.snp.bottom).inset(-20)
        })
        
    }
    
    @objc func newPlan() {
        let vc = newAndEditPlanViewController()
        vc.delegate = self
        vc.isNew = true
        self.present(vc, animated: true)
    }
   

}

extension PlanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .bgSecond
        cell.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: UIImage(data: planArr[indexPath.row].image))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.text = planArr[indexPath.row].name
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).inset(-15)
        }
        
        let imageViewArrow = UIImageView(image: UIImage.arrow)
        imageViewArrow.contentMode = .scaleAspectFit
        imageViewArrow.backgroundColor = .clear
        cell.addSubview(imageViewArrow)
        imageViewArrow.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let vc = DetailPlanViewController()
            vc.index = indexPath.row
            vc.delegateSecond = self
            self.present(vc, animated: true)
        
    }
    
    
}


extension PlanViewController: PlanViewControllerDelegate {
    func reloadTable() {
        collection?.reloadData()
        print(12)
    }
}
