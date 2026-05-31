import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let addTrackerButton = UIButton()
    private let trackersMainLabel = UILabel()
    private let mockLabel = UILabel()
    private let mockImage = UIImageView()
    private let searchBar = UISearchBar()
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var searchText = ""
    let datePicker = UIDatePicker()
    var countRecord: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        categories = [
            TrackerCategory(
                title: "Важное",
                trackers: [
                    Tracker(
                        id: UUID(),
                        name: "Бег",
                        color: .red,
                        emoji: "🏃",
                        schedule: [.monday, .wednesday, .friday]
                    ),

                    Tracker(
                        id: UUID(),
                        name: "Книга",
                        color: .blue,
                        emoji: "📚",
                        schedule: [.friday, .sunday]
                    )
                ]
            ),
            TrackerCategory(
                title: "Вторая секция",
                trackers: [
                    Tracker(
                        id: UUID(),
                        name: "Поливка растений",
                        color: .green,
                        emoji: "🌺",
                        schedule: [.monday, .wednesday, .friday]
                    ),

                    Tracker(
                        id: UUID(),
                        name: "Спортзал",
                        color: .gray,
                        emoji: "💪",
                        schedule: [.friday, .sunday]
                    )
                ]
            ),
            TrackerCategory(
                title: "Третья секция",
                trackers: [
                    Tracker(
                        id: UUID(),
                        name: "Кодинг",
                        color: .yellow,
                        emoji: "💻",
                        schedule: [.monday, .wednesday, .friday]
                    ),

                    Tracker(
                        id: UUID(),
                        name: "Игры",
                        color: .purple,
                        emoji: "🎮",
                        schedule: [.friday, .sunday]
                    )
                ]
            )
        ]
        updateVisibleCategories()
        updatePlaceholder()
    }

    //MARK: - Setup Views
    
    private func setupViews() {
        setupCollectionView()
        setupTrackersMainLabel()
        setupAddTrackerButton()
        setupDatePicker()
        setupMockImage()
        setupMockLabel()
        setupSearchBar()
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset.top = 24
    }
    
    private func setupTrackersMainLabel() {
        trackersMainLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersMainLabel.text = "Трекеры"
        trackersMainLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(trackersMainLabel)
    }
    
    private func setupAddTrackerButton() {
        addTrackerButton.setImage(
            UIImage(resource: .addPlusButton),
            for: .normal
        )
        addTrackerButton.addTarget(
            self,
            action: #selector(plusTapped),
            for: .touchUpInside
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: addTrackerButton
        )
    }
    
    @objc
    private func plusTapped() {
        print("addTracker")
    }
    
    private func setupDatePicker (){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .valueChanged
        )
        datePicker.sizeToFit()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: datePicker
        )
    }
    
    @objc
    private func dateChanged() {
        updateVisibleCategories()
        updatePlaceholder()
        collectionView.reloadData()
    }
    
    private func setupMockImage() {
        mockImage.translatesAutoresizingMaskIntoConstraints = false
        mockImage.image = UIImage(resource: .starForMiss)
        view.addSubview(mockImage)
    }
    
    private func setupMockLabel() {
        mockLabel.translatesAutoresizingMaskIntoConstraints = false
        mockLabel.text = "Что будем отслеживать?"
        mockLabel.font = .systemFont(ofSize: 12, weight: .medium)
        mockLabel.textAlignment = .center
        view.addSubview(mockLabel)
    }
    
    private func updatePlaceholder(){
        let isEmpty = visibleCategories.isEmpty
        
        mockImage.isHidden = !isEmpty
        mockLabel.isHidden = !isEmpty
        
        collectionView.isHidden = isEmpty
    }
    
    private func setupSearchBar(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        collectionViewConstraints()
        trackersMainLabelConstraints()
        mockImageConstraints()
        mockLabelConstraints()
        searchBarConstraint()
    }
    
    private func collectionViewConstraints(){
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func trackersMainLabelConstraints() {
        NSLayoutConstraint.activate([
            trackersMainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersMainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func mockImageConstraints() {
        NSLayoutConstraint.activate([
            mockImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mockImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func mockLabelConstraints() {
        NSLayoutConstraint.activate([
            mockLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mockLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mockLabel.topAnchor.constraint(equalTo: mockImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func searchBarConstraint(){
        NSLayoutConstraint.activate ([
            searchBar.topAnchor.constraint(equalTo: trackersMainLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 10)
        ])
    }
    
    //MARK: - Add or Take away Complete Tracker
    
    private func isTrackerCompleted(trackerID: UUID, date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerID == trackerID &&
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: date
            )
        }
    }
    
    func completeTracker(_ tracker: Tracker){
        let record = TrackerRecord(
            trackerID: tracker.id,
            date: datePicker.date
        )
        completedTrackers.append(record)
    }
    
    func uncompleteTracker(_ tracker: Tracker) {
        completedTrackers.removeAll{
            $0.trackerID == tracker.id &&
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: datePicker.date
            )
        }
    }
    
    private func isFutureDate() -> Bool {
        Calendar.current.startOfDay(for: datePicker.date) > Calendar.current.startOfDay(for: Date())
    }
    
    //MARK: - Visible Category
    
    private func weekDay(for date: Date) -> WeekDay {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        switch weekday {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .monday
        }
    }
    
    private func updateVisibleCategories() {
        let selectedWeekDay = weekDay(for: datePicker.date)
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let matchesWeekDay = tracker.schedule.contains(selectedWeekDay)
                let matchesSearch = searchText.isEmpty || tracker.name.localizedCaseInsensitiveContains(searchText)
                return matchesWeekDay && matchesSearch
            }
            
            guard !trackers.isEmpty else {return nil}
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackersCollectionViewCell
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.onRecordButtonTapped = { [weak self] in
            guard let self else {return}
            
            if self.isFutureDate() {
                return
            }
            
            let completed = self.isTrackerCompleted(
                trackerID: tracker.id,
                date: self.datePicker.date
            )
            
            if completed {
                self.uncompleteTracker(tracker)
            } else {
                self.completeTracker(tracker)
            }
            
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        let completed = isTrackerCompleted(
            trackerID: tracker.id,
            date: datePicker.date
        )
        
        let count = completedTrackers.filter {
            $0.trackerID == tracker.id
        }.count
        cell.topContainer.backgroundColor = tracker.color
        cell.recordButton.tintColor = tracker.color
        cell.emojiLabel.text = tracker.emoji
        cell.titleLabel.text = tracker.name
        cell.configure(isCompleted: completed, completeDays: count)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        let category = categories[indexPath.section]
        header.titleLabel.text = category.title
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9)/2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
    }
}


extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.searchText = searchText
        updateVisibleCategories()
        updatePlaceholder()
        collectionView.reloadData()
    }
}
