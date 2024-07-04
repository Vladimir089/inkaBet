//
//  AcivementsViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 04.07.2024.
//

import UIKit
import CoreImage

class AcivementsViewController: UIViewController {
    
    var segmented: UISegmentedControl?
    var selected = "All"
    var collectiom: UICollectionView?
    var falseIndices: [Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectiom?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
    }
    

    func createInterface() {
        
        let labelStat: UILabel = {
            let label = UILabel()
            label.text = "Achievements"
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
            let segmented = UISegmentedControl(items: ["All", "Unfulfilled"])
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
        
    }
    

    
    @objc func selectedChanged() {
        if selected == "All" {
            selected = "Unfulfilled"
        } else {
            selected = "All"
        }
        collectiom?.reloadData()
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return nil }
        
        return UIImage(cgImage: cgimg)
    }
    
}


extension AcivementsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        falseIndices.removeAll()
        if selected == "All" {
            return achivementArr.count
        } else {
            
            var count = 0
            for (index, value) in achivementArr.enumerated() {
                if value == false {
                    count += 1
                    falseIndices.append(index)
                }
            }
            return count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .BG
        cell.layer.cornerRadius = 16
        
        let imageView: UIImageView = {
            let image = imageArr[indexPath.row]
            let imageView = UIImageView(image: image)
            return imageView
        }()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(82)
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        label.text = textAchivArr[indexPath.row]
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
            make.left.equalTo(imageView.snp.right).inset(-15)
        }
        
        var progressView: UIProgressView = {
            let progress = UIProgressView()
            progress.backgroundColor = .white.withAlphaComponent(0.15)
            progress.progressTintColor = UIColor(red: 98/255, green: 101/255, blue: 148/255, alpha: 1)
            progress.layer.cornerRadius = 3
            return progress
        }()
        cell.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.bottom.equalToSuperview().inset(25)
        }
        
        let progressLabel = UILabel()
        progressLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        progressLabel.textColor = .white.withAlphaComponent(0.75)
        cell.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.bottom.equalTo(progressView.snp.top).inset(-10)
            
        }
        
        if achivementArr[indexPath.row] == false {
            if let originalImage = imageView.image {
                imageView.image = convertToGrayScale(image: originalImage)
            }
        }

        if selected == "Unfulfilled" {
            var a = falseIndices[indexPath.row]
            imageView.image = convertToGrayScale(image: imageArr[a])
            label.text = textAchivArr[a]
        }
        
        let currentCount = Float(workArr.count)
        switch label.text {
        case textAchivArr[0]:
            let progress = min(currentCount / 1.0, 1.0)
            progressLabel.text = "\(workArr.count)/1"
            progressView.setProgress(Float(progress), animated: false)
        case textAchivArr[1]:
            let progress = min(currentCount / 5.0, 1.0)
            progressLabel.text = "\(workArr.count)/5"
            progressView.setProgress(Float(progress), animated: false)
        case textAchivArr[2]:
            let progress = min(currentCount / 10.0, 1.0)
            progressLabel.text = "\(workArr.count)/10"
            progressView.setProgress(Float(progress), animated: false)
        case textAchivArr[3]:
            let progress = min(currentCount / 15.0, 1.0)
            progressLabel.text = "\(workArr.count)/15"
            progressView.setProgress(progress, animated: false)
        case textAchivArr[4]:
            let progress = min(currentCount / 20.0, 1.0)
            progressLabel.text = "\(workArr.count)/20"
            progressView.setProgress(Float(progress), animated: false)
        case textAchivArr[5]:
            let progress = min(currentCount / 25.0, 1.0)
            progressLabel.text = "\(workArr.count)/25"
            progressView.setProgress(Float(progress), animated: false)
        case textAchivArr[6]:
            var totalHours = 0
            
            for i in workArr {
                let hoursString = String(i.time.prefix(2))
                if let hours = Int(hoursString) {
                    totalHours += hours
                }
            }
            
            progressLabel.text = "\(totalHours)/40"
            progressView.setProgress(Float(Double(totalHours) / 40.0), animated: false)
            
        case .none:
            break
        case .some(_):
            break
        }
        
        
        
        
       
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    
}
