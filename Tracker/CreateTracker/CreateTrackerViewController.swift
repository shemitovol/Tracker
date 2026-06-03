import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let buttonsStack = UIStackView()
    private let optionTitles = [
        "Категория",
        "Расписание"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupViews()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
    }
    
    private func addSubviews() {
        view.addSubview(createButton)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStack)
        view.addSubview(collectionView)
        view.addSubview(cancelButton)
    }
    
    private func setupViews() {
        setupTitleLabel()
        setupCollectionView()
        setupButtonsStack()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая привычка"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.top = 24
        collectionView.register(NameCollectionViewCell.self, forCellWithReuseIdentifier: NameCollectionViewCell.cellIdentifier)
        collectionView.register(OptionsCollectionViewCell.self, forCellWithReuseIdentifier: OptionsCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate ([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -16)
        ])
    }
    
    private func setupButtonsStack() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 8
        NSLayoutConstraint.activate ([
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        buttonsStack.addArrangedSubview(cancelButton)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(UIColor(resource: .ypRed), for: .normal)
        cancelButton.backgroundColor = UIColor(resource: .ypWhiteDay)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(resource: .ypRed).cgColor
        cancelButton.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside
        )
        
        buttonsStack.addArrangedSubview(createButton)
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(UIColor(resource: .ypWhiteDay), for: .normal)
        createButton.backgroundColor = UIColor(resource: .ypGray)
        createButton.layer.cornerRadius = 16
        createButton.addTarget(
            self,
            action: #selector(createTapped),
            for: .touchUpInside
        )
    }

    @objc
    private func cancelTapped() {
        print("cancelTapped")
    }
    
    @objc
    private func createTapped() {
        print("createTapped")
    }
    
    private func openCategory() {
        print("openCategory")
    }
    
    private func openSchedule() {
        let scheduleVC = ScheduleViewController()
        present(scheduleVC, animated: true)
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .name:
            return 1
        case .options:
            return optionTitles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let section = Sections(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .name:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NameCollectionViewCell.cellIdentifier,
                for: indexPath) as? NameCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .options:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OptionsCollectionViewCell.cellIdentifier,
                for: indexPath) as? OptionsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let item = optionTitles[indexPath.item]
            let lastIndex = optionTitles.count - 1
            
            cell.configure(title: item, isFirst: indexPath.item == 0, isLast: indexPath.item == lastIndex)
            return cell
        }
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .name:
            break
        case .options:
            switch indexPath.item {
            case 0:
                openCategory()
            case 1:
                openSchedule()
            default:
                break
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Sections(rawValue: indexPath.section) else {
            return .zero
        }
        
        switch section {
        case .name:
            return CGSize(width: collectionView.bounds.width - 32, height: 75)
        case .options:
            return CGSize(width: collectionView.bounds.width - 32, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == Sections.options.rawValue {
            return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
