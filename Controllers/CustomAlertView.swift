import UIKit

class CustomAlertView: UIView {

    // Callback when OK is pressed
    var onOkTapped: (() -> Void)?

    init(title: String, message: String, buttonTitle: String) {
        super.init(frame: UIScreen.main.bounds)
        setupView(title: title, message: message, buttonTitle: buttonTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String, message: String, buttonTitle: String) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.56)

        let alertBox = UIView()
        alertBox.backgroundColor = .white
        alertBox.layer.cornerRadius = 12
        alertBox.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0) 
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let okButton = UIButton(type: .system)
        okButton.setTitle(buttonTitle, for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0) // Orange
        okButton.layer.cornerRadius = 8
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel, okButton])
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
            alertBox.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor, multiplier: 0.2),

            stackView.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -20),

            okButton.widthAnchor.constraint(equalTo: alertBox.widthAnchor, multiplier: 0.6),
            okButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06),
        ])
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

    @objc private func dismissAlert() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.onOkTapped?()
        }
    }
}
