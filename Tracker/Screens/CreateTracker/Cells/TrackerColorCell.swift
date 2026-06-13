import UIKit

final class TrackerColorCell: UICollectionViewCell {
    static let cellIdentifier = "colorCell"
    private let colorView = UIView()
    
    override init (frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.borderWidth = 0
        layer.borderColor = nil
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        NSLayoutConstraint.activate ([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = color.withAlphaComponent(0.3).cgColor
            layer.cornerRadius = 8
        } else {
            layer.borderWidth = 0
            layer.borderColor = nil
        }
    }
}

