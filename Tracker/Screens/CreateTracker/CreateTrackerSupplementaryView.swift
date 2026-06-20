import UIKit

final class CreateTrackerSupplementaryView: UICollectionReusableView {
    //MARK: - Public Properties
    static let headerIdentifier = "сreateTrackerHeader"
    
    //MARK: - UI Elements
    private let titleLabel = UILabel()
    
    //MARK: - Initialization
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        
        NSLayoutConstraint.activate ([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(title: String){
        titleLabel.text = title
    }
}
