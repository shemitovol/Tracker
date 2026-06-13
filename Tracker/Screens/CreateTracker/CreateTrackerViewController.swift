import UIKit

final class CreateTrackerViewController: UIViewController {
    //MARK: - Public Properties
    var onTrackerCreated: ((TrackerCategory) -> Void)?
    
    //MARK: - UI Elements
    private let titleLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let buttonsStack = UIStackView()
    private let trackerColors: [UIColor] = (1...18).compactMap {
        UIColor(named: "colorSelection\($0)")
    }
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    //MARK: - Private Properties
    private var trackerName = ""
    private var isNameWarningShow = false
    private var selectedSchedule: [WeekDay] = []
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupViews()
        updateCreateButton()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
    }
    
    //MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(createButton)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStack)
        view.addSubview(collectionView)
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
        collectionView.register(TrackerNameInputCell.self, forCellWithReuseIdentifier: TrackerNameInputCell.cellIdentifier)
        collectionView.register(OptionsCollectionViewCell.self, forCellWithReuseIdentifier: OptionsCollectionViewCell.cellIdentifier)
        collectionView.register(TrackerEmojiCell.self, forCellWithReuseIdentifier: TrackerEmojiCell.cellIdentifier)
        collectionView.register(TrackerColorCell.self, forCellWithReuseIdentifier: TrackerColorCell.cellIdentifier)
        collectionView.register(CreateTrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CreateTrackerSupplementaryView.headerIdentifier)
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
        dismiss(animated: true)
    }
    
    @objc
    private func createTapped() {
        guard
            !trackerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !selectedSchedule.isEmpty
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: trackerColors.randomElement() ?? UIColor(resource: .colorSelection1),
            emoji: "⭐️",
            schedule: selectedSchedule
        )
        
        let category = TrackerCategory(
            title: "Новая категория",
            trackers: [tracker]
        )
        
        onTrackerCreated?(category)
        dismiss(animated: true)
    }
    
    private func updateCreateButton() {
        let isEnabled = !selectedSchedule.isEmpty && !trackerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? UIColor(resource: .ypBlackDay) : UIColor(resource: .ypGray)
    }
    
    private func openCategory() {
        print("openCategory")
    }
    
    private func openSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = Set(selectedSchedule)
        
        scheduleVC.onScheduleSelected = { [weak self] days in
            guard let self else {return}
            self.selectedSchedule = days
            self.updateCreateButton()
            self.collectionView.reloadData()
        }
        
        present(scheduleVC, animated: true)
    }
    
    private func scheduleText() -> String {
        let sortedDays = selectedSchedule.sorted { $0.order < $1.order }
        let weekdays: Set<WeekDay> = [
            .monday,
            .tuesday,
            .wednesday,
            .thursday,
            .friday
        ]
        
        let weekends: Set<WeekDay> = [
            .saturday,
            .sunday
        ]
        
        let selectedSet = Set(sortedDays)
        
        if selectedSet.count == 7 {
            return "Каждый день"
        }
        
        if selectedSet == weekdays {
            return "Будни"
        }
        
        if selectedSet == weekends {
            return "Выходные"
        }
        
        return sortedDays
            .map {$0.shortName}
            .joined(separator: ", ")
    }
}

//MARK: UICollectionViewDataSource
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
            return TrackerOption.allCases.count
        case .emoji:
            return emojis.count
        case .color:
            return trackerColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let section = Sections(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .name:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerNameInputCell.cellIdentifier,
                for: indexPath) as? TrackerNameInputCell else {
                return UICollectionViewCell()
            }
            
            cell.onTextChanged = { [weak self] text in
                self?.trackerName = text
                self?.updateCreateButton()
            }
            cell.onWarningLabelChanged = { [weak self] isWarning in
                guard let self else {return}
                self.isNameWarningShow = isWarning
                UIView.performWithoutAnimation{
                    self.collectionView.performBatchUpdates(nil)
                }
            }
            
            return cell
        case .options:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OptionsCollectionViewCell.cellIdentifier,
                for: indexPath) as? OptionsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let option = TrackerOption.allCases[indexPath.item]
            let item = option.rawValue
            let value: String?
            
            if indexPath.item == 0 {
                value = "Новая категория"
            } else {
                value = selectedSchedule.isEmpty ? nil : scheduleText()
            }
            let position: CellPosition
            let count = TrackerOption.allCases.count
            
            if count == 1 {
                position = .single
            } else if indexPath.item == 0 {
                position = .first
            } else if indexPath.item == count - 1 {
                position = .last
            } else {
                position = .middle
            }
            
            cell.configure(title: item, value: value, position: position)
            return cell
        case .emoji:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerEmojiCell.cellIdentifier,
                for: indexPath) as? TrackerEmojiCell else {
                return UICollectionViewCell()
            }
            cell.configure(emoji: emojis[indexPath.item], isSelected: selectedEmojiIndex == indexPath.item)
            return cell
        case .color:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerColorCell.cellIdentifier,
                for: indexPath) as? TrackerColorCell else {
                return UICollectionViewCell()
            }
            cell.configure(color: trackerColors[indexPath.item], isSelected: selectedColorIndex == indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = Sections(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CreateTrackerSupplementaryView.headerIdentifier,
            for: indexPath
        ) as? CreateTrackerSupplementaryView else {
            return UICollectionReusableView()
        }
        
        switch section {
        case .emoji:
            header.configure(title: "Emoji")
        case .color:
            header.configure(title: "Цвет")
        default:
            header.configure(title: "")
        }
        
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .name:
            break
        case .options:
            let option = TrackerOption.allCases[indexPath.item]
            switch option {
            case .category:
                openCategory()
            case .schedule:
                openSchedule()
            }
            
        case .emoji:
            guard selectedEmojiIndex != indexPath.item else {return}
            let previousIndex = selectedEmojiIndex
            selectedEmojiIndex = indexPath.item
            var indexPaths = [indexPath]
            if let previousIndex {
                indexPaths.append(
                    IndexPath(item: previousIndex, section: indexPath.section)
                )
            }
            collectionView.reloadItems(at: indexPaths)
            
        case .color:
            guard selectedColorIndex != indexPath.item else {return}
            let previousIndex = selectedColorIndex
            selectedColorIndex = indexPath.item
            var indexPaths = [indexPath]
            if let previousIndex {
                indexPaths.append(
                    IndexPath(item: previousIndex, section: indexPath.section)
                )
            }
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Sections(rawValue: indexPath.section) else {
            return .zero
        }
        
        switch section {
        case .name:
            let height: CGFloat = isNameWarningShow ? 113 : 75
            return CGSize(width: collectionView.bounds.width - 32, height: height)
        case .options:
            return CGSize(width: collectionView.bounds.width - 32, height: 75)
        case .emoji, .color:
            let columns: CGFloat = 6
            let inset: CGFloat = 16
            let totalSpacing: CGFloat = 5 * 5
            let availableWidth = collectionView.bounds.width - inset * 2 - totalSpacing
            let itemSize = floor(availableWidth / columns)
            return CGSize(width: itemSize, height: itemSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = Sections(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .options:
            return UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16)
        case .emoji, .color:
            return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        default:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = Sections(rawValue: section) else {
            return .zero
        }
        
        switch section {
        case .emoji:
            return CGSize(width: collectionView.frame.width, height: 50)
        case .color:
            return CGSize(width: collectionView.frame.width, height: 34)
        default:
            return .zero
        }
    }
}
