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
    var kcalLabel: UILabel?
    var dailyNormLabel: GradientLabel?
    var acivementsLabel: UILabel?
    var achivementProgress: GradientProgressView?
    
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
            make.bottom.equalTo(semiCircularProgressView.snp.bottom).inset(-1)
            make.left.equalTo(semiCircularProgressView.snp.left).inset(13)
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
        
        let spendTodayLabel: UILabel = {
            let label = UILabel()
            label.text = "SPENT TODAY:"
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .white.withAlphaComponent(0.4)
            return label
        }()
        semiCircularProgressView.addSubview(spendTodayLabel)
        spendTodayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        kcalLabel = {
            let label = UILabel()
            label.text = "\(Int(kcalToday))"
            label.font = .systemFont(ofSize: 50, weight: .bold)
            label.textColor = .white
            
            let kcal = UILabel()
            kcal.text = "Kcal"
            kcal.font = .systemFont(ofSize: 26, weight: .regular)
            kcal.textColor = .white.withAlphaComponent(0.4)
            label.addSubview(kcal)
            kcal.snp.makeConstraints { make in
                make.left.equalTo(label.snp.right)
                make.top.equalTo(label.snp.centerY).offset(-7)
            }
            return label
        }()
        semiCircularProgressView.addSubview(kcalLabel!)
        kcalLabel?.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview().offset(30)
        }
        
        
        dailyNormLabel = {
            let label = GradientLabel()
            label.text = "Daily norm: \(person?.norm ?? 0) Kcal"
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.textAlignment = .center // Убедитесь, что текст выровнен по центру, если необходимо
            return label
        }()        
        semiCircularProgressView.addSubview(dailyNormLabel!)
        dailyNormLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        
        var achivementView: UIView = {
            let view = UIView()
            view.backgroundColor = .BG
            view.layer.cornerRadius = 24
            return view
        }()
        contentView.addSubview(achivementView)
        achivementView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(110)
            make.top.equalTo(midView!.snp.bottom).inset(-10)
        }
        let labelAch: UILabel = {
            let label = UILabel()
            label.text = "Achivements"
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            return label
        }()
        achivementView.addSubview(labelAch)
        labelAch.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
        }
        
        

        let additionalView = UIView()
        contentView.addSubview(additionalView)
        additionalView.snp.makeConstraints { make in
            make.top.equalTo(achivementView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
        var achivementCompleted = 0
        for i in achivementArr {
            if i == true {
                achivementCompleted += 1
            }
        }
        
        acivementsLabel = {
            let label = UILabel()
            label.text = "\(achivementCompleted)/7"
            label.textColor = UIColor(red: 42/255, green: 216/255, blue: 143/255, alpha: 1)
            label.font = .systemFont(ofSize: 17, weight: .regular)
            return label
        }()
        achivementView.addSubview(acivementsLabel!)
        acivementsLabel?.snp.makeConstraints({ make in
            make.centerY.equalTo(labelAch.snp.centerY)
            make.left.equalTo(labelAch.snp.right).inset(-5)
        })
        
        let achivImageView: UIImageView = {
            let image: UIImage = .aciv
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        achivementView.addSubview(achivImageView)
        achivImageView.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
        }
        
        achivementProgress = {
            let progress = GradientProgressView()
            progress.tintColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
            progress.clipsToBounds = true
            progress.layer.cornerRadius = 3
            return progress
        }()
        achivementView.addSubview(achivementProgress!)
        achivementProgress?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(6)
            make.bottom.equalToSuperview().inset(20)
        })
        
        achivementProgress?.setProgress(Float(achivementCompleted / 8), animated: true)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openStat))
        achivementView.addGestureRecognizer(gesture)
        
        
        
        updateProgress()
    }
    
    @objc func openStat() {
        delegate?.openVC(index: 1)
    }
    
    @objc func openWater() {
        delegate?.openWater()
        //        semiCircularProgressView.progress -= 0.1
        //        updateProgress()
    }
    
    @objc func openSteps() {
        delegate?.openSteps()
//        kcalToday += 100
//        
//        kcalLabel?.text = "\(kcalToday / (person?.norm ?? 1))"
//                semiCircularProgressView.progress += 0.1
//                updateProgress()
    }
    
    func updateProgress() {
        
        if  semiCircularProgressView.progress >= 0.96 {
            endProgressView?.alpha = 1
        } else if semiCircularProgressView.progress <= 0.96 {
            endProgressView?.alpha = 0
        }
        
        kcalLabel?.text = "\(Int(kcalToday))"
        dailyNormLabel?.text = "Daily norm: \(person?.norm ?? 0) Kcal"
        
        
        semiCircularProgressView.progress = kcalToday / CGFloat(person?.norm ?? 1)


        var achivementCompleted = 0
        for i in achivementArr {
            if i == true {
                achivementCompleted += 1
            }
        }
        acivementsLabel?.text = "\(achivementCompleted)/7"
        
        let achFloat: Float = Float(achivementCompleted)

        // Вычисление прогресса
        let totalAchivements: Float = 7.0
        let achProgress: Float = achFloat / totalAchivements

        achivementProgress?.setProgress(achProgress, animated: true)
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


class GradientLabel: UILabel {
    var gradientColors: [CGColor] = [
        UIColor(red: 255/255, green: 191/255, blue: 26/255, alpha: 1).cgColor,
        UIColor(red: 255/255, green: 64/255, blue: 128/255, alpha: 1).cgColor
    ]
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            super.draw(rect)
            return
        }
        
        // Создаем градиент
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = rect
        
        // Создаем текстовый слой
        let textLayer = CATextLayer()
        textLayer.frame = rect
        textLayer.string = text
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        
        // Устанавливаем текстовый слой как маску для градиентного слоя
        gradientLayer.mask = textLayer
        
        // Рисуем градиентный слой в контексте
        gradientLayer.render(in: context)
    }
}


import UIKit

let achievementProgress: UIProgressView = {
    let progress = UIProgressView()
    progress.tintColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
    progress.clipsToBounds = true
    progress.layer.cornerRadius = 3
    
    // Создаем градиентный слой
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
        UIColor(red: 42/255, green: 216/255, blue: 143/255, alpha: 1).cgColor,
        UIColor(red: 122/255, green: 215/255, blue: 78/255, alpha: 1).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    
    // Устанавливаем размер градиентного слоя равным размеру прогресс-бара
    gradientLayer.frame = CGRect(x: 0, y: 0, width: progress.frame.size.width, height: progress.frame.size.height)
    
    // Добавляем градиентный слой на слой прогресс-бара
    progress.layer.addSublayer(gradientLayer)
    
    return progress
}()

