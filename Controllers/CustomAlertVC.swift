import UIKit

class CustomAlertVC: UIView {

    // Callbacks for button actions
    var onCancelTapped: (() -> Void)?
    var onYesTapped: (() -> Void)?

    private var countdownTimer: Timer?
    private var remainingSeconds = 5

    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Yes (5)", for: .normal)  // ✅ Initial title with timer
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
        startCountdown()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.56)

        let alertBox = UIView()
        alertBox.backgroundColor = .white
        alertBox.layer.cornerRadius = 12
        alertBox.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Are you sure you want to exit?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = "Your progress will be lost."
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.gray
        cancelButton.layer.cornerRadius = 8
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        yesButton.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)

        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, yesButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        alertBox.addSubview(stackView)
        self.addSubview(alertBox)

        NSLayoutConstraint.activate([
            alertBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertBox.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            alertBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),

            stackView.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20),

            buttonStackView.widthAnchor.constraint(equalTo: alertBox.widthAnchor, multiplier: 0.8),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            yesButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func startCountdown() {
        updateYesButtonTitle()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                self.updateYesButtonTitle()
            } else {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
                self.yesTapped()
            }
        }
    }

    private func updateYesButtonTitle() {
        yesButton.setTitle("Yes (\(remainingSeconds))", for: .normal)
    }

    func show(in view: UIView) {
        view.addSubview(self)
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    @objc private func yesTapped() {
        countdownTimer?.invalidate() 
        countdownTimer = nil

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.onYesTapped?()
        }
    }

    @objc private func cancelTapped() {
        countdownTimer?.invalidate()  // ✅ Stop timer when Cancel is tapped
        countdownTimer = nil

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.onCancelTapped?()
        }
    }
}
