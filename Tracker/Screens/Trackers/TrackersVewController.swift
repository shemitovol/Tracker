import UIKit

final class TrackersViewController: UIViewController {
    //MARK: - UI Elements
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let addTrackerButton = UIButton()
    private let placeholder = UIView()
    private let mockLabel = UILabel()
    private let mockImage = UIImageView()
    private let datePicker = UIDatePicker()
    
    //MARK: - Private Properties
    private var currentDate: Date = Date()
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var searchText = ""
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavBar()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
        updateUI()
    }

    //MARK: - Setup UI Private Methods
    private func setupNavBar() {
        title = "Трекеры"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    }
    
    private func setupViews() {
        setupCollectionView()
        setupAddTrackerButton()
        setupMockLabel()
        setupPlaceholder()
        setupDatePicker()
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
        let container = UIView(frame: CGRect(x: -10, y: 0, width: 42, height: 42))
        addTrackerButton.tintColor = UIColor(resource: .ypBlackDay)
        addTrackerButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        addTrackerButton.center = container.center
        container.addSubview(addTrackerButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
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
        currentDate = datePicker.date
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
        let isSearching = !searchText.trimmingCharacters(in: .whitespaces).isEmpty
        let isEmpty = visibleCategories.isEmpty
       
        placeholder.isHidden = !isEmpty
        
        if isSearching {
            mockImage.image = UIImage(resource: .missSearch)
            mockLabel.text = "Ничего не найдено"
        } else {
            mockImage.image = UIImage(resource: .starForMiss)
            mockLabel.text = "Что будем отслеживать?"
        }
        
        collectionView.isHidden = isEmpty
    }
    
    //MARK: - Setup UI Constraints Private Methods
    
    private func setupConstraints() {
        collectionViewConstraints()
        placeholderConstraints()
        mockImageConstraints()
        mockLabelConstraints()
    }
    
    private func collectionViewConstraints(){
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            mockImage.centerYAnchor.constraint(equalTo: placeholder.centerYAnchor),
            mockImage.widthAnchor.constraint(equalToConstant: 80),
            mockImage.heightAnchor.constraint(equalToConstant: 80)
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
    
    //MARK: - Lifecycle Private Methods
    
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
            date: currentDate
        )
        completedTrackers.append(record)
    }
    
    private func uncompleteTracker(_ tracker: Tracker) {
        completedTrackers.removeAll{
            $0.trackerID == tracker.id &&
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: currentDate
            )
        }
    }
    
    private func isFutureDate() -> Bool {
        Calendar.current.startOfDay(for: currentDate) > Calendar.current.startOfDay(for: Date())
    }
    
    private func updateUI() {
        updateVisibleCategories()
        updatePlaceholder()
    }
    
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
        let selectedWeekDay = weekDay(for: currentDate)
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
    
    private func completedCount(for tracker: Tracker) -> Int {
        completedTrackers.filter { $0.trackerID == tracker.id }.count
    }
}

//MARK: - UICollectionViewDataSource
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
                date: currentDate
            )
            
            if completed {
                self.uncompleteTracker(tracker)
            } else {
                self.completeTracker(tracker)
            }
            
            let newCompleted = self.isTrackerCompleted(trackerID: tracker.id, date: currentDate)
            let newCount = completedCount(for: tracker)
            
            if let cell = self.collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell {
                cell.updateCompletionState(isCompleted: newCompleted, completedDays: newCount)
            }
        }
        
        let completed = isTrackerCompleted(
            trackerID: tracker.id,
            date: currentDate
        )
        
        let count = completedCount(for: tracker)
        
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

//MARK: - UICollectionViewDelegateFlowLayout
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

//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        searchText = text
        updateUI()
    }
}

//MARK: - UISearchControllerDelegate
extension TrackersViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        searchText = ""
        updateUI()
    }
}
