import UIKit

final class NameCollectionViewCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let topContainer = UIView()
    private let trackerNameTextField = UITextField()
    private let warningLabel = UILabel()
    static let cellIdentifier = "nameCell"
    var onTextChanged: ((String) -> Void)?
    var onWarningLabelChanged: ((Bool) -> Void)?
    override init (frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews () {
        contentView.backgroundColor = UIColor(resource: .ypWhiteDay)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        NSLayoutConstraint.activate ([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = UIColor(resource: .ypBackgroundDay)
        topContainer.layer.cornerRadius = 16
        NSLayoutConstraint.activate ([
            topContainer.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        topContainer.addSubview(trackerNameTextField)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.delegate = self
        NSLayoutConstraint.activate ([
            trackerNameTextField.topAnchor.constraint(equalTo: topContainer.topAnchor),
            trackerNameTextField.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(warningLabel)
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        warningLabel.textColor = UIColor(resource: .ypRed)
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
    }
}

extension NameCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        let isValid = updatedText.count <= 38
        warningLabel.isHidden = isValid
        onWarningLabelChanged?(!isValid)
        if isValid {
            onTextChanged?(updatedText)
        }
        return isValid
    }
}
