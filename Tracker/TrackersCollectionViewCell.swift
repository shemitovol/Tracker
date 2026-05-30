import UIKit

class TrackersCollectionViewCell: UICollectionViewCell {
    let topContainer = UIView()
    let emojiLabel = UILabel()
    let titleLabel = UILabel()

    let daysLabel = UILabel()
    let readyButton = UIButton()
    
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
        topContainer.backgroundColor = .green
        
        topContainer.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
              
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate ([
            topContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: 8),
            readyButton.widthAnchor.constraint(equalToConstant: 34),
            readyButton.heightAnchor.constraint(equalToConstant: 34),
            readyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            readyButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor)
        ])
    }
    
    private func setupReadyButton() {
        readyButton.setImage(
            UIImage(resource: .readyPlusButton),
            for: .normal
        )
        readyButton.addTarget(
            self,
            action: #selector(readyTapped),
            for: .touchUpInside
        )
        readyButton.tintColor = topContainer.backgroundColor
    }
    
    @objc
    private func readyTapped (){
        print("ready tapped")
    }
}

