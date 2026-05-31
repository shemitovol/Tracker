import UIKit

class TrackersCollectionViewCell: UICollectionViewCell {
    let topContainer = UIView()
    let emojiLabel = UILabel()
    let titleLabel = UILabel()

    let daysLabel = UILabel()
    let recordButton = UIButton()
    
    var onRecordButtonTapped: (() -> Void)?
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupReadyButton()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.layer.cornerRadius = 16
        
        topContainer.addSubview(emojiLabel)
        emojiLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emojiLabel.backgroundColor = UIColor(resource: .ypWhiteDay).withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topContainer.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypWhiteDay)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
              
        contentView.addSubview(daysLabel)
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = UIColor(resource: .ypBlackDay)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate ([
            topContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: 8),
            recordButton.widthAnchor.constraint(equalToConstant: 34),
            recordButton.heightAnchor.constraint(equalToConstant: 34),
            recordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            recordButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor)
        ])
    }
    
    private func setupReadyButton() {
        recordButton.setImage(
            UIImage(resource: .readyPlusButton),
            for: .normal
        )
        recordButton.addTarget(
            self,
            action: #selector(recordTapped),
            for: .touchUpInside
        )
        recordButton.tintColor = topContainer.backgroundColor
    }
    
    @objc
    private func recordTapped (){
        onRecordButtonTapped?()
    }
    
    func configure(isCompleted: Bool, completeDays: Int) {
        daysLabel.text = "\(completeDays) дней"
        
        let image = isCompleted ? UIImage(resource: .doneButton) : UIImage(resource: .readyPlusButton)
        recordButton.setImage(image, for: .normal)
    }
}

