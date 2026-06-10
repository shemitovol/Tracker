import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    //MARK: - Public Properties
    static let cellIdentifier = "cell"
    
    var onRecordButtonTapped: (() -> Void)?
    
    //MARK: - UI Elements
    private let topContainer = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let daysLabel = UILabel()
    private let recordButton = UIButton()
    
    //MARK: - Initialization
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupRecordButton()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        onRecordButtonTapped = nil
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
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
            daysLabel.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -8),
            recordButton.widthAnchor.constraint(equalToConstant: 34),
            recordButton.heightAnchor.constraint(equalToConstant: 34),
            recordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            recordButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor)
        ])
    }
    
    private func setupRecordButton() {
        recordButton.setImage(
            UIImage(resource: .readyPlusButton),
            for: .normal
        )
        recordButton.addTarget(
            self,
            action: #selector(recordTapped),
            for: .touchUpInside
        )
    }
    
    @objc
    private func recordTapped (){
        onRecordButtonTapped?()
    }
    
    private func daysText(_ count: Int) -> String {
        let lastOne = count % 10
        let lastTwo = count % 100
        
        if lastTwo >= 11 && lastTwo <= 14 {
            return "\(count) дней"
        }
        
        switch lastOne {
        case 1:
            return "\(count) день"
        case 2...4:
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
    }
    
    //MARK: - Public Methods
    func configure(tracker: Tracker, isCompleted: Bool, completeDays: Int) {
        topContainer.backgroundColor = tracker.color
        recordButton.tintColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        updateCompletionState(isCompleted: isCompleted, completedDays: completeDays)
    }
    
    func updateCompletionState(isCompleted: Bool, completedDays: Int) {
        daysLabel.text = daysText(completedDays)
        let image = isCompleted ? UIImage(resource: .doneButton) : UIImage(resource: .readyPlusButton)
        recordButton.setImage(image, for: .normal)
    }
}

