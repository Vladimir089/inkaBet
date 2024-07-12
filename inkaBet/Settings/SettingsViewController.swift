//
//  SettingsViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 05.07.2024.
//

import UIKit
import WebKit
import StoreKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
    }
    

    func createInterface() {
        let labelStat: UILabel = {
            let label = UILabel()
            label.text = "Settings"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        view.addSubview(labelStat)
        labelStat.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        let userPolButton = createButton(tag: 1)
        view.addSubview(userPolButton)
        userPolButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelStat.snp.bottom).inset(-30)
        }
        userPolButton.addTarget(self, action: #selector(policy), for: .touchUpInside)
        
        let shareButton = createButton(tag: 2)
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(userPolButton.snp.bottom).inset(-10)
        }
        shareButton.addTarget(self, action: #selector(shareApp), for: .touchUpInside)
        
        let rateButton = createButton(tag: 3)
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(shareButton.snp.bottom).inset(-10)
        }
        rateButton.addTarget(self, action: #selector(rateApp), for: .touchUpInside)
        
    }
    
    //MARK: -objc
    
    @objc func shareApp() {
        let appURL = URL(string: "https://apps.apple.com/app/gainsguru/id6526495618")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "https://www.termsfeed.com/live/20e7917c-4e12-44cf-9b01-da5f8cea8760"
        present(webVC, animated: true, completion: nil)
    }
    

    @objc func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "https://apps.apple.com/app/gainsguru/id6526495618") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    
    
    func createButton(tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .BG
        
        let imageArrow = UIImage.arrow
        let imageViewArrow = UIImageView(image: imageArrow)
        imageViewArrow.contentMode = .scaleAspectFit
        button.addSubview(imageViewArrow)
        imageViewArrow.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(17)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        
        switch tag {
        case 1:
            let image = UIImage.pol
            iconImageView.image = image
            button.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            label.text = "Usage Policy"
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(iconImageView.snp.right).inset(-15)
            }
        case 2:
            let image = UIImage.share
            iconImageView.image = image
            button.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            label.text = "Share app"
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(iconImageView.snp.right).inset(-15)
            }
        case 3:
            let image = UIImage.star
            iconImageView.image = image
            button.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            label.text = "Rate app"
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(iconImageView.snp.right).inset(-15)
            }
        default:
            break
        }
        
        return button
    }
    

}


class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
