import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let addTrackerButton = UIButton()
    private let trackersMainLabel = UILabel()
    private let placeholder = UIView()
    private let mockLabel = UILabel()
    private let mockImage = UIImageView()
    private let searchBar = UISearchBar()
    private let datePicker = UIDatePicker()
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
        updateUI()
    }

    //MARK: - Setup Views
    
    private func setupViews() {
        setupCollectionView()
        setupTrackersMainLabel()
        setupAddTrackerButton()
        setupPlaceholder()
        setupDatePicker()
        setupSearchBar()
    }
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.cellIdentifier)
        collectionView.register(TrackersSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersSupplementaryView.headerIdentifier)
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
        let createTrackerVC = CreateTrackerViewController()
        
        createTrackerVC.onTrackerCreated = { [weak self] category in
            guard let self else { return }
            
            self.categories.append(category)
            self.updateUI()
        }
        present(createTrackerVC, animated: true)
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
        updateUI()
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholder)
        placeholder.addSubview(mockImage)
        placeholder.addSubview(mockLabel)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupMockLabel() {
        mockLabel.font = .systemFont(ofSize: 12, weight: .medium)
        mockLabel.textAlignment = .center
    }
    
    private func updatePlaceholder(){
        let isSearching = !(searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isEmpty = visibleCategories.isEmpty
       
        placeholder.isHidden = !isEmpty
        
        if isSearching {
            mockImage.image = UIImage(resource: .missSearch)
            mockLabel.text = "Ничего не найдено"
            setupMockLabel()
        } else {
            mockImage.image = UIImage(resource: .starForMiss)
            mockLabel.text = "Что будем отслеживать?"
            setupMockLabel()
        }
        
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
        placeholderConstraints()
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
    
    private func placeholderConstraints(){
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func mockImageConstraints() {
        mockImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mockImage.centerXAnchor.constraint(equalTo: placeholder.centerXAnchor),
            mockImage.centerYAnchor.constraint(equalTo: placeholder.centerYAnchor)
        ])
    }
    
    private func mockLabelConstraints() {
        mockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mockLabel.leadingAnchor.constraint(equalTo: placeholder.leadingAnchor, constant: 16),
            mockLabel.trailingAnchor.constraint(equalTo: placeholder.trailingAnchor, constant: -16),
            mockLabel.topAnchor.constraint(equalTo: mockImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func searchBarConstraint(){
        NSLayoutConstraint.activate ([
            searchBar.topAnchor.constraint(equalTo: trackersMainLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Lifecycle
    
    private func isTrackerCompleted(trackerID: UUID, date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerID == trackerID &&
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: date
            )
        }
    }
    
    private func completeTracker(_ tracker: Tracker){
        let record = TrackerRecord(
            trackerID: tracker.id,
            date: datePicker.date
        )
        completedTrackers.append(record)
    }
    
    private func uncompleteTracker(_ tracker: Tracker) {
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
    
    private func updateUI() {
        updateVisibleCategories()
        updatePlaceholder()
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
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier,
            for: indexPath) as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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
        
        cell.configure(tracker: tracker, isCompleted: completed, completeDays: count)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.headerIdentifier,
            for: indexPath
        ) as? TrackersSupplementaryView else {
            return UICollectionReusableView()
        }
        
        let category = visibleCategories[indexPath.section]
        header.configure(title: category.title)
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
        updateUI()
    }
}
