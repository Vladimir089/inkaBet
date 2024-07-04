//
//  ReviewerOnbViewController.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit
import SnapKit



class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let pages: [OnboardingContentViewController]
    var pageControl = UIPageControl()
    
    init() {
        self.pages = [
            OnboardingContentViewController(imageName: "oneL", text: "Train with GainsGuru App", pageCount: 4, currentPage: 0),
            OnboardingContentViewController(imageName: "twoL", text: "Enter results and get achievements", pageCount: 4, currentPage: 1),
            OnboardingContentViewController(imageName: "threeL", text: "Track progress towards your goals", pageCount: 4, currentPage: 2),
            OnboardingContentViewController(imageName: "fourL", text: "Welcome to GainsGuru", pageCount: 4, currentPage: 3)
        ]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingContentViewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! OnboardingContentViewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first as? OnboardingContentViewController,
              let index = pages.firstIndex(of: viewController) else { return }
        pageControl.currentPage = index
    }
}

protocol OnboardingContentViewControllerDelegate: AnyObject {
    func saved()
}

class OnboardingContentViewController: UIViewController {
    
    let imageView = UIImageView()
    let textLabel = UILabel()
    let nextButton = UIButton(type: .system)
    let pageControl = UIPageControl()
    var page: Int?
    
    init(imageName: String, text: String, pageCount: Int, currentPage: Int) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        textLabel.text = text
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = currentPage
        page = currentPage
        view.backgroundColor = .BG
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(textLabel)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        imageView.contentMode = .scaleAspectFit
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 3
        textLabel.font = .systemFont(ofSize: 34, weight: .bold)
        textLabel.textColor = .white
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.setTitleColor(.BG, for: .normal)
        nextButton.backgroundColor = .primary
        nextButton.layer.cornerRadius = 16
        
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        pageControl.isUserInteractionEnabled = false
        
        
        
        
        
        
        
        setupLayout()
    }
    
    func setupLayout() {
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(63)
            make.right.equalToSuperview().inset(150)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerY.equalTo(nextButton.snp.centerY)
            make.right.equalToSuperview().inset(30)
            
        }
        
        textLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-40)
            make.left.right.equalToSuperview().inset(30)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(textLabel.snp.top).inset(-30)
        }
        
        
        
        if page == 3 {
            nextButton.addTarget(self, action: #selector(creteNewPerson), for: .touchUpInside)
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(50)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(379)
            }
            
            let labelDesc: UILabel = {
                let label = UILabel()
                label.text = "To make our application as useful as possible for you, fill out your information"
                label.numberOfLines = 4
                label.font = .systemFont(ofSize: 15, weight: .regular)
                label.textColor = UIColor(red: 101/255, green: 101/255, blue: 107/255, alpha: 1)
                return label
            }()
            view.addSubview(labelDesc)
            labelDesc.snp.makeConstraints { make in
                make.bottom.equalTo(nextButton.snp.top).inset(-55)
                make.left.equalToSuperview().inset(30)
                make.right.equalToSuperview().inset(100)
            }
            
            textLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(labelDesc.snp.top).inset(-25)
                make.left.equalToSuperview().inset(30)
                make.right.equalToSuperview().inset(30)
            }
            
            
        }
        
        
    }
    
    @objc func creteNewPerson() {
        let vc = NewUserViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let pageViewController = parent as? OnboardingViewController,
           let currentIndex = pageViewController.pages.firstIndex(of: self) {
            let nextIndex = currentIndex + 1
            if nextIndex < pageViewController.pages.count {
                let nextVC = pageViewController.pages[nextIndex]
                pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
                pageViewController.pageControl.currentPage = nextIndex
            }
        }
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        if let pageViewController = parent as? OnboardingViewController {
            let currentIndex = sender.currentPage
            let direction: UIPageViewController.NavigationDirection = currentIndex > pageViewController.pageControl.currentPage ? .forward : .reverse
            pageViewController.setViewControllers([pageViewController.pages[currentIndex]], direction: direction, animated: true, completion: nil)
            pageViewController.pageControl.currentPage = currentIndex
        }
    }
}


extension OnboardingContentViewController: OnboardingContentViewControllerDelegate {
    func saved() {
        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
    }
}
