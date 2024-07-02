//
//  StatView.swift
//  inkaBet
//
//  Created by Владимир Кацап on 02.07.2024.
//

import UIKit

class StatView: UIView {
    
    var delegate: StatisticsViewControllerDelegate?
    //UI
    var waterLabel, stepLabel: UILabel?
    var waterProgress, stepProgress: UIProgressView?
    var waterCount, waterRequired,  stepCount, stepRequired: Float?
    var midView: UIView?
    let semiCircularProgressView = SemiCircularProgressView()
    var endProgressView: UIView?
    
    var progressRotation = 0
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        createInterface()
        backgroundColor = .bgSecond
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createInterface() {
        
        let labelStat: UILabel = {
            let label = UILabel()
            label.text = "Statistics"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        addSubview(labelStat)
        labelStat.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        
        let scroll = UIScrollView()
        addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(labelStat.snp.bottom)
        }
        
        
        let contentView = UIView()
        scroll.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalTo(scroll)
        }
        
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 10
            stack.alignment = .fill
            stack.distribution = .fillEqually
            return stack
        }()
        scroll.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(139)
            make.top.equalToSuperview().inset(30)
        }
        
        let waterView = createView(isWater: true)
        let stepsView = createView(isWater: false)
        stackView.addArrangedSubview(waterView)
        stackView.addArrangedSubview(stepsView)
        
        let waterGesture = UITapGestureRecognizer(target: self, action: #selector(openWater))
        waterView.addGestureRecognizer(waterGesture)
        let stepsGesture = UITapGestureRecognizer(target: self, action: #selector(openSteps))
        stepsView.addGestureRecognizer(stepsGesture)
        
        midView = {
            let view = UIView()
            view.backgroundColor = .BG
            view.layer.cornerRadius = 26
            return view
        }()
        contentView.addSubview(midView!)
        midView?.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(291)
            make.top.equalTo(stackView.snp.bottom).inset(-10)
        }
        
        
        // Добавление полукруглого прогресс бара в midView
        
        midView?.addSubview(semiCircularProgressView)
        semiCircularProgressView.clipsToBounds = true
        semiCircularProgressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(282)
            make.height.equalTo(204)
        }
        semiCircularProgressView.progress = 0
        
        var startProgressView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 26/255, alpha: 1)
            view.layer.cornerRadius = 2
            view.transform = CGAffineTransform(rotationAngle: 158 * .pi / 180)
            return view
        }()
        midView?.addSubview(startProgressView)
        startProgressView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(26)
            make.bottom.equalTo(semiCircularProgressView.snp.bottom).inset(1.5)
            make.left.equalTo(semiCircularProgressView.snp.left).inset(12)
        }
        
        endProgressView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 128/255, alpha: 1)
            view.layer.cornerRadius = 2
            view.transform = CGAffineTransform(rotationAngle: -153 * .pi / 180)
            return view
        }()
        midView?.addSubview(endProgressView!)
        endProgressView?.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(26)
            make.bottom.equalTo(semiCircularProgressView.snp.bottom).inset(-1)
            make.right.equalTo(semiCircularProgressView.snp.right).inset(13)
        }
        
        
//        // Пример добавления дополнительного контента для проверки прокрутки
//                let additionalView = UIView()
//                additionalView.backgroundColor = .red
//                contentView.addSubview(additionalView)
//                additionalView.snp.makeConstraints { make in
//                    make.top.equalTo(stackView.snp.bottom).offset(20)
//                    make.left.right.equalToSuperview()
//                    make.height.equalTo(5000) // Добавляем высоту, чтобы контент был прокручиваемым
//                    make.bottom.equalToSuperview()
//                }
        updateProgress()
    }
    
    @objc func openWater() {
        delegate?.openWater()
//        semiCircularProgressView.progress -= 0.1
//        updateProgress()
    }
    
    @objc func openSteps() {
        delegate?.openSteps()
//        semiCircularProgressView.progress += 0.1
//        updateProgress()
    }
    
    func updateProgress() {

        if  semiCircularProgressView.progress >= 0.96 {
            endProgressView?.alpha = 1
        } else if semiCircularProgressView.progress <= 0.96 {
            endProgressView?.alpha = 0
        }

    }
    
    
    
    
    
    func createView(isWater: Bool) -> UIView {
        let view = UIView()
        view.backgroundColor = .BG
        view.layer.cornerRadius = 24
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(label.snp.centerY)
        }
        
        
        if isWater == true {
            label.text = "Water"
            imageView.image = .water
            
            waterLabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = .systemFont(ofSize: 20, weight: .semibold)
                label.text = "\(Int(waterCount ?? 0))/\(Int(waterRequired ?? 0))"
                return label
            }()
            view.addSubview(waterLabel!)
            waterLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(10)
            })
            
            waterProgress = {
                let progress = GradientProgressView()
                progress.layer.cornerRadius = 3
                progress.clipsToBounds = true
                progress.tintColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
                progress.setProgress(Float(waterCount ?? 0), animated: true)
                return progress
            }()
            view.addSubview(waterProgress!)
            waterProgress?.snp.makeConstraints({ make in
                make.height.equalTo(6)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(waterLabel!.snp.bottom).inset(-10)
            })
            
        } else {
            
            label.text = "Steps"
            imageView.image = .steps
            stepLabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = .systemFont(ofSize: 20, weight: .semibold)
                label.text = "\(Int(stepCount  ?? 0))/\(Int(stepRequired  ?? 0))"
                return label
            }()
            view.addSubview(stepLabel!)
            stepLabel?.snp.makeConstraints({ make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(10)
            })
            
            stepProgress = {
                let progress = GradientProgressViewStep()
                progress.layer.cornerRadius = 3
                progress.clipsToBounds = true
                progress.tintColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
                progress.setProgress(Float(stepCount ?? 0), animated: true)
               
                return progress
            }()
            view.addSubview(stepProgress!)
            stepProgress?.snp.makeConstraints({ make in
                make.height.equalTo(6)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(stepLabel!.snp.bottom).inset(-10)
            })
        }
        
        
        return view
    }
    
    
    
}








class GradientProgressView: UIProgressView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 191/255, blue: 26/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 64/255, blue: 128/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
        layer.masksToBounds = true
    }
    
    private func updateGradientFrame() {
        let progressWidth = CGFloat(progress) * bounds.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
    }
    
    override var progress: Float {
        didSet {
            updateGradientFrame()
        }
    }
}




class GradientProgressViewStep: UIProgressView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 133/255, green: 124/255, blue: 254/255, alpha: 1).cgColor,
            UIColor(red: 67/255, green: 121/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
        layer.masksToBounds = true
    }
    
    private func updateGradientFrame() {
        let progressWidth = CGFloat(progress) * bounds.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
    }
    
    override var progress: Float {
        didSet {
            updateGradientFrame()
        }
    }
}






import UIKit

class SemiCircularProgressView: UIView {
    
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }

    private let gradientLayer = CAGradientLayer()
    private let progressShapeLayer = CAShapeLayer()
    private let divisionsShapeLayer = CAShapeLayer()
    private let segmentsShapeLayer = CAShapeLayer()
    private let endSegmentGradientLayer = CAGradientLayer()
    private let endSegmentShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 191/255, blue: 26/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 64/255, blue: 128/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        progressShapeLayer.lineWidth = 5.0
        progressShapeLayer.fillColor = nil
        progressShapeLayer.strokeColor = UIColor.black.cgColor
        progressShapeLayer.lineCap = .round
        gradientLayer.mask = progressShapeLayer
        
        divisionsShapeLayer.lineWidth = 2.0
        divisionsShapeLayer.strokeColor = UIColor.white.cgColor
        divisionsShapeLayer.fillColor = nil
        layer.addSublayer(divisionsShapeLayer)
        
        segmentsShapeLayer.lineWidth = 5.0
        segmentsShapeLayer.strokeColor = UIColor.red.cgColor
        segmentsShapeLayer.fillColor = nil
        segmentsShapeLayer.lineCap = .round
        layer.addSublayer(segmentsShapeLayer)
        
        endSegmentGradientLayer.colors = [
            UIColor(red: 255/255, green: 191/255, blue: 26/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 64/255, blue: 128/255, alpha: 1).cgColor
        ]
        endSegmentGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        endSegmentGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(endSegmentGradientLayer)
        
        endSegmentShapeLayer.lineWidth = 5.0
        endSegmentShapeLayer.fillColor = nil
        endSegmentShapeLayer.lineCap = .round
        endSegmentGradientLayer.mask = endSegmentShapeLayer
    }
    
    private func angleIsInProgressRange(angle: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> Bool {
        return angle >= startAngle && angle <= endAngle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        endSegmentGradientLayer.frame = bounds
        
        let padding: CGFloat = 6.0 // Отступы со всех сторон
        let lineWidth: CGFloat = 5.0
        let divisionLineWidth: CGFloat = 2.0
        let segmentLength: CGFloat = 20.0 // Длина отрезков
        let radius = (min(bounds.width, bounds.height * 2) - lineWidth - 2 * padding) / 2 // Учитываем отступы
        let center = CGPoint(x: bounds.width / 2, y: radius + lineWidth / 2 + padding) // Учитываем отступы
        let startAngle = CGFloat.pi * 2.85
        let endAngle = startAngle + (1.35 * CGFloat.pi * progress)
        
        // Смещение центра прогресс-дуги, чтобы она совпадала с центром делений
        let progressRadius = radius - divisionLineWidth / 2
        
        // Рисование прогресса
        let progressPath = UIBezierPath()
        progressPath.addArc(withCenter: center, radius: progressRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressShapeLayer.path = progressPath.cgPath
        
        // Рисование делений
        let divisionsPath = UIBezierPath()
        let numberOfMarks = 90
        for i in 0..<numberOfMarks {
            let angle = startAngle + (3.3 * CGFloat.pi / 2 * CGFloat(i) / CGFloat(numberOfMarks - 1))
            // Пропуск делений, которые перекрываются прогрессом
            if angle <= endAngle {
                continue
            }
            let markStart = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let markEnd = CGPoint(x: center.x + (radius - lineWidth) * cos(angle), y: center.y + (radius - lineWidth) * sin(angle))
            divisionsPath.move(to: markStart)
            divisionsPath.addLine(to: markEnd)
        }
        divisionsShapeLayer.path = divisionsPath.cgPath
        
        // Рисование отрезков в начале прогресса
        let segmentsPath = UIBezierPath()
        let segmentOffset: CGFloat = 0.02 // Смещение угла влево и вправо
        
        
        
        
        segmentsShapeLayer.path = segmentsPath.cgPath
        
        // Рисование отрезка в конце прогресса
        let endSegmentPath = UIBezierPath()
        let endSegmentAngle = endAngle + segmentOffset
        let endSegmentStart = CGPoint(x: center.x + (radius + segmentLength / 2) * cos(endSegmentAngle), y: center.y + (radius + segmentLength / 2) * sin(endSegmentAngle))
        let endSegmentEnd = CGPoint(x: center.x + (radius - segmentLength / 2) * cos(endSegmentAngle), y: center.y + (radius - segmentLength / 2) * sin(endSegmentAngle))
        endSegmentPath.move(to: endSegmentStart)
        endSegmentPath.addLine(to: endSegmentEnd)
        
        endSegmentShapeLayer.path = endSegmentPath.cgPath
        endSegmentShapeLayer.strokeColor = UIColor.black.cgColor
        endSegmentShapeLayer.strokeColor = gradientLayer.colors![0] as! CGColor // Используется первый цвет градиента
        if progress >= 0.96 {
            endSegmentShapeLayer.strokeColor = UIColor.clear.cgColor
        }
        if progress == 0 {
            endSegmentShapeLayer.strokeColor = UIColor.clear.cgColor
        }
    }
}
