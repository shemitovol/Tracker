import UIKit

final class NameCollectionViewCell: UICollectionViewCell {
    private let trackerNameTextField = UITextField()
    
    static let cellIdentifier = "nameCell"
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews () {
        contentView.backgroundColor = UIColor(resource: .ypBackgroundDay)
        contentView.layer.cornerRadius = 16
        contentView.addSubview(trackerNameTextField)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.placeholder = "Введите название трекера"
        
        NSLayoutConstraint.activate ([
            trackerNameTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41)
        ])
    }
}
