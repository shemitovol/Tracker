import UIKit

final class OptionsCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let chevronImage = UIImageView()
    private let dividerView = UIView()
    private let labelsStack = UIStackView()
    
    static let cellIdentifier = "optionsCell"
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        addSubviews()
        setupViews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(chevronImage)
        contentView.addSubview(labelsStack)
        contentView.addSubview(dividerView)
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(resource: .ypBackgroundDay)
        
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.image = UIImage(resource: .chevron)
        NSLayoutConstraint.activate ([
            chevronImage.heightAnchor.constraint(equalToConstant: 24),
            chevronImage.widthAnchor.constraint(equalToConstant: 24),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.axis = .vertical
        labelsStack.spacing = 2
        labelsStack.alignment = .leading
        NSLayoutConstraint.activate ([
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -1)
        ])
        
        labelsStack.addArrangedSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        
        labelsStack.addArrangedSubview(valueLabel)
        valueLabel.font = .systemFont(ofSize: 17, weight: .regular)
        valueLabel.textColor = UIColor(resource: .ypGray)

        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor(resource: .ypGray)
        NSLayoutConstraint.activate ([
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    func configure (title: String, value: String?, isFirst: Bool, isLast: Bool) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.isHidden = value == nil
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        if isFirst && isLast {
            layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else if isFirst {
            layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        } else if isLast {
            layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else {
            layer.maskedCorners = []
        }
        
        dividerView.isHidden = isLast
    }
}

