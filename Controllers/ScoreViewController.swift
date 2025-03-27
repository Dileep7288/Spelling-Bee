import UIKit

class ScoreViewController: UIViewController {
    
    var totalTimeTaken: Int = 0
    var totalScore: Int = 0
    var hintCount: Int = 0
    var correctWordsCount: Int = 0
    var wrongWordsCount: Int = 0
    var totalWords: Int = 0
    var isPracticeMode: Bool = false
    var incorrectWords: [String] = []
    var incorrectWordsHint: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWrongWordsPopup()
    }

    private func showWrongWordsPopup() {
        guard !incorrectWords.isEmpty else { return }
        
        let alert = UIAlertController(
            title: "Practice Again?",
            message: "Would you like to practice again with the words you got wrong?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.navigateToPracticeVC()
        }
        
        let noAction = UIAlertAction(title: "No", style: .destructive) { _ in
            self.incorrectWords.removeAll()
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpUI() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "backGround")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        let overLayView = UIView(frame: view.bounds)
        overLayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overLayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overLayView)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let trophySize = screenWidth * 0.20

        let trophyImageView = UIImageView()
        trophyImageView.image = UIImage(named: "trophy")
        trophyImageView.tintColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        trophyImageView.contentMode = .scaleAspectFit
        trophyImageView.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(trophyImageView)

        let congratsFontSize = screenWidth * 0.07
        let completionFontSize = screenWidth * 0.035

        let congratsLabel = UILabel()
        congratsLabel.text = "Congratulations!"
        congratsLabel.font = UIFont(name: "Poppins-Bold", size: congratsFontSize)
        congratsLabel.textColor = .white
        congratsLabel.textAlignment = .center
        congratsLabel.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(congratsLabel)

        let completionLabel = UILabel()
        completionLabel.text = "You have completed the Spelling Bee game!"
        completionLabel.font = UIFont(name: "Poppins-Regular", size: completionFontSize)
        completionLabel.textColor = .white
        completionLabel.textAlignment = .center
        completionLabel.numberOfLines = 0
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(completionLabel)
        
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.alignment = .center
        starStackView.distribution = .equalSpacing
        starStackView.spacing = 10
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(starStackView)
        
        let totalStars = 3
        let correctRatio = totalWords > 0 ? CGFloat(correctWordsCount) / CGFloat(totalWords) : 0
        let starsToFill = correctRatio * CGFloat(totalStars)

        let starSizes: [CGFloat] = [
            screenWidth * 0.12,
            screenWidth * 0.2,
            screenWidth * 0.12
        ]

        if isPracticeMode{
            starStackView.isHidden = true
        }else{
            for i in 0..<totalStars {
                let starContainer = UIView()
                starContainer.translatesAutoresizingMaskIntoConstraints = false
                starContainer.widthAnchor.constraint(equalToConstant: starSizes[i]).isActive = true
                starContainer.heightAnchor.constraint(equalToConstant: starSizes[i]).isActive = true
                
                let starOutline = UIImageView()
                starOutline.image = UIImage(systemName: "star")
                starOutline.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
                starOutline.contentMode = .scaleAspectFit
                starOutline.translatesAutoresizingMaskIntoConstraints = false
                starContainer.addSubview(starOutline)
                
                let starFill = UIImageView()
                starFill.image = UIImage(systemName: "star.fill")
                starFill.tintColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
                starFill.contentMode = .scaleAspectFit
                starFill.translatesAutoresizingMaskIntoConstraints = false
                starContainer.addSubview(starFill)
                
                let maskView = UIView()
                maskView.backgroundColor = .black
                maskView.translatesAutoresizingMaskIntoConstraints = false
                starFill.mask = maskView
                
                NSLayoutConstraint.activate([
                    starOutline.widthAnchor.constraint(equalTo: starContainer.widthAnchor),
                    starOutline.heightAnchor.constraint(equalTo: starContainer.heightAnchor),
                    starFill.widthAnchor.constraint(equalTo: starContainer.widthAnchor),
                    starFill.heightAnchor.constraint(equalTo: starContainer.heightAnchor)
                ])
                
                starStackView.addArrangedSubview(starContainer)
                
                starContainer.layoutIfNeeded()
                
                let fillPercentage = min(1.0, max(0.0, starsToFill - CGFloat(i)))
                maskView.frame = CGRect(x: 0, y: 0, width: starFill.bounds.width * fillPercentage, height: starFill.bounds.height)
            }
        }
        
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.alignment = .fill
        gridStackView.distribution = .equalSpacing
        gridStackView.spacing = 10
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(gridStackView)
        
        let boxContents: [(UIImage?, String, String, UIColor, UIColor)] = [
            (UIImage(systemName: "list.bullet"), "Total Words", "\(totalWords)", UIColor(red: 255/255, green: 251/255, blue: 235/255, alpha: 1.0), .blue),
            (UIImage(systemName: "checkmark.circle.fill"), "Correct", "\(correctWordsCount)", UIColor(red: 236/255, green: 253/255, blue: 245/255, alpha: 1.0), .green),
            (UIImage(systemName: "xmark.circle.fill"), "Wrong", "\(wrongWordsCount)", UIColor(red: 254/255, green: 242/255, blue: 242/255, alpha: 1.0), .red),
            (UIImage(systemName: "clock"), "Time Taken", "\(totalTimeTaken)s", UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0), .black),
            (UIImage(systemName: "star.fill"), "Score", "\(min(100, max(0, totalScore)))", UIColor(red: 245/255, green: 243/255, blue: 255/255, alpha: 1.0), .yellow),
            (UIImage(named: "7"), "Hints Used", "\(hintCount)", UIColor(red: 255/255, green: 247/255, blue: 237/255, alpha: 1.0), .orange) 
        ]


        for i in 0..<3 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            gridStackView.addArrangedSubview(rowStackView)

            for j in 0..<2 {
                let index = i * 2 + j
                if index < boxContents.count {
                    let (image, title, value, bgColor, iconColor) = boxContents[index]
                    let box = createBox(image: image, title: title, value: value, backgroundColor: bgColor, imageColor: iconColor)
                    rowStackView.addArrangedSubview(box)
                }
            }
        }

        let playAgainButton = UIButton(type: .system)
        let icon = UIImage(systemName: "arrow.trianglehead.clockwise.rotate.90")?.withRenderingMode(.alwaysTemplate)
        playAgainButton.setImage(icon, for: .normal)
        playAgainButton.tintColor = .white
        playAgainButton.setTitle(" Play Again", for: .normal)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.045)
        playAgainButton.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
        playAgainButton.layer.cornerRadius = 10
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.imageView?.contentMode = .scaleAspectFit
        playAgainButton.semanticContentAttribute = .forceLeftToRight
        playAgainButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        playAgainButton.addTarget(self, action: #selector(playAgainButtonTapped), for: .touchUpInside)
        
        let exitButton = UIButton(type: .system)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.045)
        exitButton.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
        exitButton.layer.cornerRadius = 10
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        overLayView.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        let practiceAgainButton = UIButton(type: .system)
        practiceAgainButton.setImage(icon, for: .normal)
        practiceAgainButton.tintColor = .white
        practiceAgainButton.setTitle(" Practice Again", for: .normal)
        practiceAgainButton.setTitleColor(.white, for: .normal)
        practiceAgainButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.045)
        practiceAgainButton.backgroundColor = UIColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0)
        practiceAgainButton.layer.cornerRadius = 10
        practiceAgainButton.translatesAutoresizingMaskIntoConstraints = false
        practiceAgainButton.imageView?.contentMode = .scaleAspectFit
        practiceAgainButton.semanticContentAttribute = .forceLeftToRight
        practiceAgainButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        practiceAgainButton.addTarget(self, action: #selector(practiceAgainButtonTapped), for: .touchUpInside)
        
        if isPracticeMode {
            overLayView.addSubview(practiceAgainButton)
        }else{
            overLayView.addSubview(playAgainButton)
        }

        var buttonConstraints: [NSLayoutConstraint] = [
            overLayView.topAnchor.constraint(equalTo: view.topAnchor),
            overLayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overLayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overLayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trophyImageView.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
            trophyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.005),
            trophyImageView.widthAnchor.constraint(equalToConstant: trophySize),
            trophyImageView.heightAnchor.constraint(equalToConstant: trophySize),
            
            congratsLabel.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
            congratsLabel.topAnchor.constraint(equalTo: trophyImageView.bottomAnchor, constant: screenHeight * 0.02),
            
            completionLabel.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
            completionLabel.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: screenHeight * 0.01),
            completionLabel.leadingAnchor.constraint(equalTo: overLayView.leadingAnchor, constant: screenWidth * 0.05),
            completionLabel.trailingAnchor.constraint(equalTo: overLayView.trailingAnchor, constant: -screenWidth * 0.05),
            
            starStackView.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
            starStackView.topAnchor.constraint(equalTo: completionLabel.bottomAnchor, constant: 10),
            
            gridStackView.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
            gridStackView.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 20),
            gridStackView.widthAnchor.constraint(equalTo: overLayView.widthAnchor, multiplier: 0.8),
        ]

        if isPracticeMode {
            buttonConstraints.append(contentsOf: [
                practiceAgainButton.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
                practiceAgainButton.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 35),
                practiceAgainButton.widthAnchor.constraint(equalTo: overLayView.widthAnchor, multiplier: 0.8),
                practiceAgainButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.06),
                
                exitButton.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
                exitButton.topAnchor.constraint(equalTo: practiceAgainButton.bottomAnchor, constant: 20),
                exitButton.widthAnchor.constraint(equalTo: overLayView.widthAnchor, multiplier: 0.8),
                exitButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.06)
            ])
        } else {
            buttonConstraints.append(contentsOf: [
                playAgainButton.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
                playAgainButton.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
                playAgainButton.widthAnchor.constraint(equalTo: overLayView.widthAnchor, multiplier: 0.8),
                playAgainButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.06),
                
                exitButton.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor),
                exitButton.topAnchor.constraint(equalTo: playAgainButton.bottomAnchor, constant: 20),
                exitButton.widthAnchor.constraint(equalTo: overLayView.widthAnchor, multiplier: 0.8),
                exitButton.heightAnchor.constraint(equalToConstant: screenHeight * 0.06)
            ])
        }

        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    private func createBox(image: UIImage?, title: String, value: String, backgroundColor: UIColor, imageColor: UIColor) -> UIView {
        let boxView = UIView()
        boxView.backgroundColor = backgroundColor
        boxView.layer.cornerRadius = 10
        boxView.translatesAutoresizingMaskIntoConstraints = false

        let dynamicHeight = UIScreen.main.bounds.height * 0.12
        boxView.heightAnchor.constraint(equalToConstant: dynamicHeight).isActive = true

        var valueView: UIView

        if title == "Score" {
            let score = totalScore
            let maxPossibleScore = totalWords * 10
            let progress = CGFloat(score) / CGFloat(maxPossibleScore)

            let progressView = CircularProgressView()
            progressView.totalWords = totalWords
            progressView.maxScore = CGFloat(maxPossibleScore)
            progressView.progress = CGFloat(score)  
            progressView.translatesAutoresizingMaskIntoConstraints = false

            valueView = UIView()
            valueView.translatesAutoresizingMaskIntoConstraints = false
            valueView.addSubview(progressView)

            NSLayoutConstraint.activate([
                progressView.centerXAnchor.constraint(equalTo: valueView.centerXAnchor),
                progressView.centerYAnchor.constraint(equalTo: valueView.centerYAnchor),
                progressView.widthAnchor.constraint(equalToConstant: dynamicHeight * 0.7),
                progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor)
            ])
        } else {
            let imageView = UIImageView()
  
            imageView.image = image
            imageView.tintColor = imageColor
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: dynamicHeight * 0.23).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: dynamicHeight * 0.23).isActive = true

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .black
            titleLabel.font = UIFont(name: "Poppins-Bold", size: dynamicHeight * 0.17)
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.textColor = .blue
            valueLabel.font = UIFont(name: "Poppins-Bold", size: dynamicHeight * 0.20)
            valueLabel.textAlignment = .center
            valueLabel.translatesAutoresizingMaskIntoConstraints = false

            let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, valueLabel])
            stackView.axis = .vertical
            stackView.spacing = dynamicHeight * 0.05
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
            valueView = stackView
        }

        let stackView = UIStackView(arrangedSubviews: [valueView])
        stackView.axis = .vertical
        stackView.spacing = dynamicHeight * 0.1
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        boxView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: boxView.widthAnchor, multiplier: 0.8)
        ])

        return boxView
    }

    @objc func playAgainButtonTapped(){
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @objc func exitButtonTapped(){
//        let main = Main()
//        navigationController?.pushViewController(main, animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func practiceAgainButtonTapped(){
        let practice = PracticeViewController()
        navigationController?.pushViewController(practice, animated: true)
    }
    
    private func navigateToPracticeVC() {
        let practiceVC = PracticeViewController()
        practiceVC.incorrectWords = incorrectWords
        practiceVC.incorrectWordsHint = incorrectWordsHint
        navigationController?.pushViewController(practiceVC, animated: true)
    }
}
