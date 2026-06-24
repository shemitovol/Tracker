import UIKit

final class CreateCategoryViewController: UIViewController {

    //MARK: - UI Elements
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let doneButton = UIButton()
    private let stackView = UIStackView()
    private let topContainer = UIView()
    private let warningLabel = UILabel()

    //MARK: - Public Properties
    var onCreate: ((String) -> Void)?
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
        setupUI()
        setupTextField()
        updateButtonState()
    }

    //MARK: - Private Methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая категория"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        titleLabel.textAlignment = .center

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor(resource: .ypWhiteDay), for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.backgroundColor = UIColor(resource: .ypBlackDay)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextField() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        NSLayoutConstraint.activate ([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = UIColor(resource: .ypBackgroundDay)
        topContainer.layer.cornerRadius = 16
        NSLayoutConstraint.activate ([
            topContainer.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        topContainer.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название категории"
        textField.font = .systemFont(ofSize: 17)
        textField.textColor = UIColor(resource: .ypBlackDay)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        NSLayoutConstraint.activate ([
            textField.topAnchor.constraint(equalTo: topContainer.topAnchor),
            textField.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(warningLabel)
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        warningLabel.textColor = UIColor(resource: .ypRed)
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
    }

    @objc private func textChanged() {
        updateButtonState()
    }

    private func updateButtonState() {
        let isValid = !(textField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        doneButton.isEnabled = isValid
        doneButton.backgroundColor = isValid ? UIColor(resource: .ypBlackDay) : UIColor(resource: .ypGray)
    }

    @objc private func doneTapped() {
        guard
            let title = textField.text?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !title.isEmpty
        else {
            return
        }

        onCreate?(title)
        dismiss(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        let isValid = updatedText.count <= 38
        warningLabel.isHidden = isValid
        return isValid
    }
}
