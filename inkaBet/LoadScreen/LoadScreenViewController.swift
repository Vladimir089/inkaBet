//
//  LoadScreenViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit
import SnapKit

class LoadScreenViewController: UIViewController {
    
    var progressBar: UIProgressView?
    var progressLabel: UILabel?
    var progress: Float = 0.0
    var timer: Timer?
    let totalDuration: Float = 1.0 //МЕНЯТЬ менять


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        createInterface()
        startProgressBar()
    }
    
    func createInterface() {
        let imageView: UIImageView = {
            let image = UIImage(named: "loadImage")
            let imageView = UIImageView(image: image)
            return imageView
        }()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(241)
            make.width.equalTo(264)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-85)
        }
        
        progressLabel = {
            let label = UILabel()
            label.text = "Loading \(Int(progress * 100))%"
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.textColor = .white.withAlphaComponent(0.7)
            label.textAlignment = .center
            return label
        }()
        
        view.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        })
        
        progressBar = {
            let progress = UIProgressView(progressViewStyle: .bar)
            progress.setProgress(0, animated: true)
            progress.progressTintColor = .primary
            progress.backgroundColor = .white.withAlphaComponent(0.3)
            progress.layer.cornerRadius = 1.5
            return progress
        }()
        view.addSubview(progressBar!)
        progressBar?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressLabel!.snp.top).inset(-15)
        })
    }
    
    func startProgressBar() {
        let interval = totalDuration / 100.0 // Интервал обновления прогресса
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        progress += 0.01
        progressBar?.setProgress(progress, animated: true)
        progressLabel?.text = "Loading \(Int(progress * 100))%"
        
        if progress >= 1.0 {
            timer?.invalidate()
            timer = nil
            navigateToNextScreen()
        }
    }
    
    func navigateToNextScreen() {
        if isUser {
            if ((UserDefaults.standard.object(forKey: "onbUser") != nil) == true) {
                self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
            } else {
                self.navigationController?.setViewControllers([OnboardingViewController()], animated: true)
            }
        } else {
            //
        }
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
