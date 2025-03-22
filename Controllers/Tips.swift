import UIKit

class Tips: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    
    private let instructions: [Instruction] = [
        Instruction(
            title: "Game Objective",
            points: [
                (UIImage(named: "1")!, "Spell the word correctly."),
                (UIImage(named: "2")!, "15 seconds per word"),
                (UIImage(named: "3")!, "Listen to the word and type it")
            ]
        ),
        Instruction(
            title: "How To Play",
            points: [
                (UIImage(named: "4")!, "Click 'Start' to begin your challenge"),
                (UIImage(named: "5")!, "Words will be pronounced"),
                (UIImage(named: "6")!, "Type your answer in the text box")
            ]
        ),
        Instruction(
            title: "Tips For Success",
            points: [
                (UIImage(named: "7")!, "Stay focused and avoid distractions"),
                (UIImage(named: "8")!, "Practice commonly misspelled words"),
                (UIImage(named: "9")!, "Use available hints and definitions")
            ]
        ),
        Instruction(
            title: "How It Works",
            points: [
                (UIImage(named: "10")!, "Improve spelling in a fun, timed environment"),
                (UIImage(named: "10")!, "Earn points for correct answers"),
                (UIImage(named: "10")!, "Fast-paced gameplay for excitement")
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        titleLabel.text = "Spelling Bee"
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
        
        // ✅ Set UICollectionView to Scroll Full Screen
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InstructionCell.self, forCellWithReuseIdentifier: InstructionCell.identifier)
        
        view.addSubview(collectionView)
        
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
            
            // ✅ Full Screen Scrolling
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor) // ✅ Extends to bottom
        ])
    }

    
    @objc private func backButtonTapped() {
        navigateToMainScreen()
    }
    
    private func navigateToMainScreen() {
        let main = Main()
        navigationController?.pushViewController(main, animated: true)
    }
    
    // MARK: - UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instructions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructionCell.identifier, for: indexPath) as? InstructionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: instructions[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 220)
    }
}
