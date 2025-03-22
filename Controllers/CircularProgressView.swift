import UIKit

class CircularProgressView: UIView {
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let percentageLabel = UILabel()

    var maxScore: CGFloat = 100 {  // ✅ Now dynamically settable
        didSet {
            updateProgressBar()
        }
    }

    var progress: CGFloat = 0 {
        didSet {
            let adjustedProgress = min(progress / maxScore, 1.0)  // ✅ Scales dynamically
            updateProgress(adjustedProgress)
        }
    }
    
    var totalWords: Int = 1 {  // ✅ Default to 1 to prevent division by zero
        didSet {
            updateProgressBar()  // ✅ Update progress when totalWords changes
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        percentageLabel.textColor = .black
        percentageLabel.text = "0"
        addSubview(percentageLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = min(bounds.width, bounds.height) / 2.5
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = 6
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = 6
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        percentageLabel.frame = bounds
    }

    private func updateProgress(_ adjustedProgress: CGFloat) {
        let percentage = totalWords > 0 ? (progress / CGFloat(totalWords * 10)) * 100 : 0
        let displayPercentage = Int(percentage)
        percentageLabel.text = "\(displayPercentage)%"
        
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = adjustedProgress
            animation.duration = 0.5
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            self.progressLayer.add(animation, forKey: "progressAnim")
        }
    }

    private func updateProgressBar() {
        let adjustedProgress = min(progress / maxScore, 1.0)
        updateProgress(adjustedProgress)
    }
}
