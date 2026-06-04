import UIKit

final class ScheduleCollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()
    private let dividerView = UIView()
    var onSwitchChanged: ((Bool) -> Void)?
    
    static let cellIdentifier = "scheduleCell"
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        addSubviews()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onSwitchChanged = nil
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(switchControl)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dividerView)
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(resource: .ypBackgroundDay)
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(
            self,
            action: #selector(switchValueChanged),
            for: .valueChanged
        )
        NSLayoutConstraint.activate ([
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        NSLayoutConstraint.activate ([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16)
        ])
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor(resource: .ypGray)
        NSLayoutConstraint.activate ([
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    @objc
    private func switchValueChanged() {
        onSwitchChanged?(switchControl.isOn)
    }
    
    func configure (title: String, isSelected: Bool, isFirst: Bool, isLast: Bool) {
        titleLabel.text = title
        switchControl.isOn = isSelected
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
