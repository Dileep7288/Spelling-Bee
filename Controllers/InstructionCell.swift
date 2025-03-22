import UIKit

class InstructionCell: UICollectionViewCell {
    static let identifier = "InstructionCell"

    private let containerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 9
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        contentView.addSubview(containerView)
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(stackView)

        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with instruction: Instruction) {
        titleLabel.text = instruction.title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for point in instruction.points {
            let pointView = UIStackView()
            pointView.axis = .horizontal
            pointView.spacing = 12
            pointView.alignment = .center

            let imageView = UIImageView(image: point.image)
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

            let label = UILabel()
            label.text = point.text
            label.numberOfLines = 0
            label.font = UIFont(name: "Poppins-Regular", size: 16)

            pointView.addArrangedSubview(imageView)
            pointView.addArrangedSubview(label)

            stackView.addArrangedSubview(pointView)
        }
    }
}
