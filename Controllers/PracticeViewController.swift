import UIKit
import AVFoundation

class PracticeViewController: UIViewController,UITextFieldDelegate {
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    private var inputTextField = PaddedTextField()
    private var timerStarted = false
    private var timerLabel: UILabel!
    private var countdownTimer: Timer?
    private var remainingTime = 15
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var words: [String] = []
    private var sentences: [String] = []
    private var currentIndex = 0
    private var currentWord = ""
    private var score = 0
    private var scoreLabel: UILabel!
    private var progressLabel: UILabel!
    private var gradientView: UIView!
    private var gradientLayer: CAGradientLayer!
    private var gradientViewWidthConstraint: NSLayoutConstraint!
    private var hintButton: UIButton!
    private var submitButton: UIButton!
    private var gameStartTime: Date?
    private var correctWords: Int = 0
    private var wrongWords: Int = 0
    private var submitDate: String?
    private var currentHint = ""
    private var hintCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchSpellBeeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextField.becomeFirstResponder()
        showSpeakerPopup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    private func showSpeakerPopup() {

        self.view.endEditing(true)

        let customAlert = CustomAlertView(
            title: "How to Play?",
            message: "Click the Mic icon or the 'Hear It' button to listen to the word. Once you hear it, type the word into the input box below. Good luck!",
            buttonTitle: "PROCEED"
        )

        customAlert.onOkTapped = {
            self.updateProgress()
            self.startGame()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.inputTextField.becomeFirstResponder()
            }
        }

        customAlert.show(in: self.view)
    }

    private func startGame() {
        gameStartTime = Date()
        startTimer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return false
     }

     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
     }

    private func setupUI() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "backGround")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.text = "Practice Mode"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 32)
        titleLabel.textColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [backButton, titleLabel])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 10
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerStack)
        
        let scoreCard = createCard(title: "Score:", value: "0", isTimer: false)
        let timerCard = createCard(title: "", value: "0 sec", isTimer: true)
        let progressCard = createProgressCard()

        if let label = timerCard.subviews.first(where: { $0 is UIStackView })?.subviews.last as? UILabel {
            timerLabel = label
        }

        view.addSubview(scoreCard)
        view.addSubview(timerCard)
        view.addSubview(progressCard)

        scoreCard.translatesAutoresizingMaskIntoConstraints = false
        timerCard.translatesAutoresizingMaskIntoConstraints = false
        progressCard.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),

            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            headerStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.centerYAnchor.constraint(equalTo: headerStack.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerStack.trailingAnchor),

            scoreCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            scoreCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreCard.widthAnchor.constraint(equalToConstant: screenWidth * 0.3),
            scoreCard.heightAnchor.constraint(equalToConstant: screenHeight * 0.055),

            timerCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            timerCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerCard.widthAnchor.constraint(equalToConstant: screenWidth * 0.3),
            timerCard.heightAnchor.constraint(equalToConstant: screenHeight * 0.055),

            progressCard.topAnchor.constraint(equalTo: scoreCard.bottomAnchor, constant: 15),
            progressCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressCard.widthAnchor.constraint(equalToConstant: screenWidth * 0.9),
            progressCard.heightAnchor.constraint(equalToConstant: screenHeight * 0.07)
        ])

        let speakerCard = createSpeakerCard()
        view.addSubview(speakerCard)
        speakerCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speakerCard.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 15),
            speakerCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speakerCard.widthAnchor.constraint(equalToConstant: screenWidth * 0.9),
            speakerCard.heightAnchor.constraint(equalToConstant: screenHeight * 0.3)
        ])
    }
    
    // MARK: - API Call
    private func fetchSpellBeeData() {
        let urlString = APIConstants.practiceApi
         guard let url = URL(string: urlString) else {
             print("❌ Invalid URL")
             return
         }

         let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
             guard let self = self, let data = data, error == nil else {
                 print("❌ Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                 return
             }

             do {
                 let words = try JSONDecoder().decode([String].self, from: data)
                 
                 DispatchQueue.main.async {
                     self.words = words
                     self.submitDate = self.getCurrentDate()

                     if !self.words.isEmpty {
                         self.updateCurrentWord()
                         self.updateProgress()
                     } else {
                         print("⚠️ No words found in API response.")
                     }
                 }
             } catch {
                 print("❌ Error decoding JSON: \(error.localizedDescription)")
             }
         }

         task.resume()
     }

     private func getCurrentDate() -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         return dateFormatter.string(from: Date())
     }

    // MARK: - Back Button Action
    @objc private func backButtonTapped() {
        navigateToMainScreen()
    }
    
    private func navigateToMainScreen() {
        let main = Main()
        navigationController?.pushViewController(main, animated: true)
    }
    
    // MARK: - Timer Functionality
    private func startTimer() {
        countdownTimer?.invalidate()
        remainingTime = 0
        updateTimerLabel()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.remainingTime += 1
            self.updateTimerLabel()
        }
        
        timerStarted = true
    }

    private func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        timerStarted = false
    }

    private func timerFinished() {
        stopTimer()
        inputTextField.resignFirstResponder()
    }

    private func moveToNextWord() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
            updateCurrentWord()
            updateProgress()
            resetTimer()
            startTimer()
        } else {
            navigateToScoreScreen()
        }
    }
    
    private func navigateToScoreScreen() {
        stopTimer()
        isNavigatingToScore = true

        let totalTimeTaken = gameStartTime != nil ? Int(Date().timeIntervalSince(gameStartTime!)) : 0

        DispatchQueue.main.async {
            self.inputTextField.resignFirstResponder()
            self.view.endEditing(true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let scoreVC = ScoreViewController()
            scoreVC.totalTimeTaken = totalTimeTaken
            scoreVC.totalScore = self.score
            scoreVC.totalWords = self.words.count
            scoreVC.hintCount = self.hintCount
            scoreVC.correctWordsCount = self.correctWords
            scoreVC.wrongWordsCount = self.wrongWords
            scoreVC.isPracticeMode = true
            self.navigationController?.pushViewController(scoreVC, animated: true)
        }
    }
    
    private func resetPracticeMode() {
        let practice = PracticeViewController()
        navigationController?.pushViewController(practice, animated: true)
    }

    private func navigateToGameScreen() {
        let game = GameViewController()
        navigationController?.pushViewController(game, animated: true)
    }

    private func updateTimerLabel() {
        timerLabel.text = String(format: "%02d sec", remainingTime)
        timerLabel.textColor = .black
    }
    
    private func resetTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 15
        updateTimerLabel()
        timerStarted = false
    }
    
    // MARK: - Speaker & Hint Actions
    @objc private func speakerTapped() {
        speakText(currentWord)
        if !timerStarted {
            startTimer()
        }
    }

    private func speakText(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        speechSynthesizer.speak(utterance)
    }
    
    @objc private func submitTapped() {
        inputTextField.resignFirstResponder()
        guard let userInput = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userInput.isEmpty else {
            //showCustomAlert(title: "Error", message: "Please enter a word.")
            return
        }
        
        let isCorrect = userInput.lowercased() == currentWord.lowercased()
        let title = isCorrect ? "🎉 Correct!" : "❌ Incorrect"
        var message: String

        countdownTimer?.invalidate()
        countdownTimer = nil
        
        if isCorrect {
            correctWords += 1
            score += 10
            message = "Good job! You spelled the word correctly."
            updateScoreLabel()
        } else {
            wrongWords += 1
            message = "Oops! The correct spelling is '\(currentWord)'."
        }
        showCustomAlert(title: title, message: message)
    }
    
    private var alertView: UIView?
    private var isAlertVisible = false

    private var alertBackgroundView: UIView?

    private func showCustomAlert(title: String, message: String) {
        if isAlertVisible { return }
        isAlertVisible = true

        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        self.alertBackgroundView = backgroundView
        view.addSubview(backgroundView)

        let alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 12
        alertView.clipsToBounds = true
        alertView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .black
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let okButton = UIButton(type: .system)
        okButton.setTitle("Next", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0)
        okButton.layer.cornerRadius = 8
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(handleOKButton), for: .touchUpInside)

        let buttonContainer = UIStackView(arrangedSubviews: [UIView(), okButton])
        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 10
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false

        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(buttonContainer)
        backgroundView.addSubview(alertView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),

            buttonContainer.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            buttonContainer.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            buttonContainer.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            buttonContainer.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            
            okButton.widthAnchor.constraint(equalToConstant: 80),
            okButton.heightAnchor.constraint(equalToConstant: 44),

            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 50),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])

        self.alertView = alertView

        alertView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 0.3) {
            alertView.transform = .identity
        }
    }

    private var isNavigatingToScore = false

    @objc private func handleOKButton() {
        inputTextField.text = ""
        moveToNextWord()
        updateProgress()

        alertView?.isUserInteractionEnabled = false

        if let alertView = self.alertView {
            UIView.animate(withDuration: 0.3, animations: {
                alertView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                self.alertBackgroundView?.alpha = 0
            }) { _ in
                alertView.removeFromSuperview()
                self.alertBackgroundView?.removeFromSuperview()
                self.alertView = nil
                self.alertBackgroundView = nil
                self.isAlertVisible = false

                if !self.isNavigatingToScore {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.inputTextField.becomeFirstResponder()
                    }
                }
            }
        }
    }

    // MARK: - Update Score Label
    private func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    private func updateProgress() {

        guard words.count > 0 else {
            //print("❌ words.count is zero. Cannot update progress.")
            return
        }

        let progress = Float(min(currentIndex + 1, words.count)) / Float(words.count)

        progressView.setProgress(progress, animated: true)
        progressLabel.text = "\(currentIndex + 1)/\(words.count) Words"

        self.view.layoutIfNeeded()

        guard progressView.frame.width > 0 else {
            //print("❌ progressView has zero width")
            return
        }

        let newWidth = progressView.frame.width * CGFloat(progress)

        if newWidth.isNaN || newWidth.isInfinite {
            //print("❌ Invalid width detected: \(newWidth)")
            return
        }

        gradientViewWidthConstraint.constant = newWidth

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.gradientLayer.frame = self.gradientView.bounds
        }
    }

    private func updateCurrentWord() {
        guard currentIndex < words.count else { return }
        currentWord = words[currentIndex]
        timerStarted = false
    }
    
    private func createCard(title: String, value: String, isTimer: Bool) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        cardView.layer.cornerRadius = 24

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 16)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .black
        valueLabel.font = UIFont(name: "Poppins-Regular", size: 20)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel]) 
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])

        if title == "Score:" {
            scoreLabel = valueLabel
        } else if title == "Time:" {
            timerLabel = valueLabel
        }

        return cardView
    }

    //MARK: Progress Card
    private func createProgressCard() -> UIView {
        let cardView = UIView()

        progressLabel = UILabel()
        progressLabel.text = "0/\(words.count) Words"
        progressLabel.textColor = .white
        progressLabel.font = UIFont(name: "Poppins-Bold", size: 16)

        progressView.progress = 0.0
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .clear
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 5
        gradientView.clipsToBounds = true

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1.0).cgColor,
            UIColor(red: 52/255, green: 211/255, blue: 153/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 5
        gradientView.layer.addSublayer(gradientLayer)

        cardView.addSubview(progressLabel)
        cardView.addSubview(progressView)
        cardView.insertSubview(gradientView, aboveSubview: progressView)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            progressLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),

            progressView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            progressView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            progressView.heightAnchor.constraint(equalToConstant: 12),
            progressView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -13),

            gradientView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            gradientView.topAnchor.constraint(equalTo: progressView.topAnchor),
            gradientView.heightAnchor.constraint(equalTo: progressView.heightAnchor),
        ])

        gradientViewWidthConstraint = gradientView.widthAnchor.constraint(equalToConstant: 0)
        gradientViewWidthConstraint.isActive = true

        DispatchQueue.main.async {
            self.gradientLayer.frame = self.gradientView.bounds
        }

        return cardView
    }

    private func createSpeakerCard() -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0).cgColor
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let speakerImageView = UIImageView()
        speakerImageView.image = UIImage(systemName: "speaker.wave.3.fill")
        speakerImageView.contentMode = .scaleAspectFit
        speakerImageView.tintColor = UIColor(white: 1.0, alpha: 0.85)
        speakerImageView.widthAnchor.constraint(equalToConstant: screenWidth * 0.15).isActive = true
        speakerImageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.07).isActive = true
        
        speakerImageView.isUserInteractionEnabled = true
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(speakerTapped))
        speakerImageView.addGestureRecognizer(tapGesture)

        let tapToListenLabel = UILabel()
        tapToListenLabel.text = "Tap to Listen"
        tapToListenLabel.textColor = .white
        tapToListenLabel.font = UIFont.systemFont(ofSize: 13)
        tapToListenLabel.textAlignment = .center
        inputTextField = PaddedTextField()
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Type here...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        inputTextField.borderStyle = .none
        inputTextField.backgroundColor = .white
        inputTextField.font = UIFont.systemFont(ofSize: 18)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .black
        inputTextField.layer.cornerRadius = 5
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.gray.cgColor
        inputTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        inputTextField.autocorrectionType = .no
        inputTextField.spellCheckingType = .no
        inputTextField.smartQuotesType = .no
        inputTextField.smartDashesType = .no
        inputTextField.smartInsertDeleteType = .no

        inputTextField.inputAssistantItem.leadingBarButtonGroups = []
        inputTextField.inputAssistantItem.trailingBarButtonGroups = []

        inputTextField.inputAccessoryView = UIView(frame: .zero)

        hintButton = UIButton(type: .system)
        hintButton.setTitle(" Hint", for: .normal)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.backgroundColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        hintButton.layer.cornerRadius = 8
        hintButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
        hintButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)

        let bulbImage = UIImage(systemName: "lightbulb")?.withRenderingMode(.alwaysTemplate)
        hintButton.setImage(bulbImage, for: .normal)
        hintButton.tintColor = .white

        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1.0)
        submitButton.layer.cornerRadius = 8
        submitButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let buttonStackView = UIStackView(arrangedSubviews: [hintButton, submitButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10

        let mainStackView = UIStackView(arrangedSubviews: [speakerImageView, tapToListenLabel, inputTextField, buttonStackView])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 13
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])

        return cardView
    }
    
    @objc private func hintButtonTapped() {
        hintCount += 1
        speakText(currentHint)
    }
}
