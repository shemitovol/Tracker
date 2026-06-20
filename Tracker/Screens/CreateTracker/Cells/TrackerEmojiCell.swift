import UIKit

final class TrackerEmojiCell: UICollectionViewCell {
    static let cellIdentifier = "emojiCell"
    private let emojiLabel = UILabel()
    
    override init (frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(emojiLabel)
        contentView.layer.cornerRadius = 16
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 32, weight: .bold)
        NSLayoutConstraint.activate ([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? UIColor(resource: .ypLightGray) : .clear
    }
}

