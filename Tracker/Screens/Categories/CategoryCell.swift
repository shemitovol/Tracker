import UIKit

final class CategoryCell: UITableViewCell {

    //MARK: - Private Properties
    private let checkmark = UIImageView()
    private let dividerView = UIView()
    private let titleLabel = UILabel()

    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(resource: .ypBackgroundDay)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Public Methods
    func configure(title: String, isSelected: Bool, position: CellPosition) {
        titleLabel.text = title
        checkmark.isHidden = !isSelected
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16

        switch position {
        case .single:
            contentView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            dividerView.isHidden = true
        case .first:
            contentView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
            dividerView.isHidden = false
        case .middle:
            contentView.layer.maskedCorners = []
            dividerView.isHidden = false
        case .last:
            contentView.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            dividerView.isHidden = true
        }
    }

    //MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmark)
        contentView.addSubview(dividerView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            checkmark.centerYAnchor.constraint( equalTo: contentView.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            checkmark.heightAnchor.constraint(equalToConstant: 24),

            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint( equalTo: contentView.bottomAnchor),
            dividerView.heightAnchor.constraint( equalToConstant: 1 / UIScreen.main.scale)
        ])

        dividerView.backgroundColor = UIColor(resource: .ypGray)
        checkmark.image = UIImage(resource: .done)
        checkmark.isHidden = true
    }
}
