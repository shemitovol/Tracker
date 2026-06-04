import UIKit

final class ScheduleViewController: UIViewController {
    private let titleLabel = UILabel()
    private let readyButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var selectedDays: Set<WeekDay> = []
    var onScheduleSelected: (([WeekDay]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupViews()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
    }
    
    private func setupViews() {
        setupTitleLabel()
        setupReadyButton()
        setupCollectionView()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(readyButton)
        view.addSubview(collectionView)
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Расписание"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func setupReadyButton() {
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.setTitle("Готово", for: .normal)
        readyButton.setTitleColor(UIColor(resource: .ypWhiteDay), for: .normal)
        readyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        readyButton.backgroundColor = UIColor(resource: .ypBlackDay)
        readyButton.layer.cornerRadius = 16
        readyButton.addTarget(
            self,
            action: #selector(readyTapped),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func readyTapped() {
        let sortedDays = selectedDays.sorted { $0.order < $1.order }
        onScheduleSelected?(sortedDays)
        dismiss(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.top = 16
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate ([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -16)
        ])
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScheduleCollectionViewCell.cellIdentifier,
            for: indexPath) as? ScheduleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let day = WeekDay.allCases[indexPath.item]
        let lastIndex = WeekDay.allCases.count - 1
        
        cell.configure(title: day.rawValue, isSelected: selectedDays.contains(day), isFirst: indexPath.item == 0, isLast: indexPath.item == lastIndex)
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else {return}
            
            if isOn {
                self.selectedDays.insert(day)
            } else {
                self.selectedDays.remove(day)
            }
        }
        return cell
    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: 75)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
