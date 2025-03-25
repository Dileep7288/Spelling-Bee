import UIKit

class Main: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "backGround"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let centerImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "crown"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Spelling Bee"
        label.textColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "''Master the Words, Conquer the \nChallenge!''"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Buttons
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let practiceModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Practice Mode", for: .normal)
        button.setTitleColor(UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor(red: 212/255.0, green: 175/255.0, blue: 55/255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let leaderBoardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("How To Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = UIScreen.main.bounds.width
        titleLabel.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.09)
        subtitleLabel.font = UIFont(name: "Poppins-Light", size: screenWidth * 0.045)
        playButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.04)
        practiceModeButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.04)
        leaderBoardButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: screenWidth * 0.04)
        setupUI()
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside )
        practiceModeButton.addTarget(self, action: #selector(practiceButtonTapped), for: .touchUpInside )
        leaderBoardButton.addTarget(self, action: #selector(leaderBoardTapped), for: .touchUpInside)
    }
    
    //MARK: Setting UI
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(centerImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(playButton)
        view.addSubview(practiceModeButton)
        view.addSubview(leaderBoardButton)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            centerImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -25),
            centerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            centerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            centerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),

            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -40),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            practiceModeButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            practiceModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            practiceModeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            practiceModeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            leaderBoardButton.topAnchor.constraint(equalTo: practiceModeButton.bottomAnchor, constant: 15),
            leaderBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderBoardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            leaderBoardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
        ])

    }
    
    @objc private func playButtonTapped() {
        let gamevc = GameViewController()
        navigationController?.pushViewController(gamevc, animated: true)
    }
    
    @objc private func practiceButtonTapped(){
        let practice = PracticeViewController()
        navigationController?.pushViewController(practice, animated: true)
    }
    
    @objc private func leaderBoardTapped(){
        let tips = Tips()
        navigationController?.pushViewController(tips, animated: true)
    }
}
