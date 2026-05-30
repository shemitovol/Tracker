import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let addTrackerButton = UIButton()
    private let trackersMainLabel = UILabel()
    private let mockLabel = UILabel()
    private let mockImage = UIImageView()
    private let searchBar = UISearchBar()
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
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
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    private func setupDatePicker (){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: datePicker
        )
    }
    
    @objc
    private func plusTapped() {
        print("addTracker")
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
    
    private func setupSearchBar(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
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
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Add or Take away Complete Tracker
    
    func completeTracker(_ tracker: Tracker){
        let record = TrackerRecord(
            trackerID: tracker.id,
            date: Date()
        )
        completedTrackers.append(record)
    }
    
    func uncompleateTracker(_ tracker: Tracker) {
        completedTrackers.removeAll{
            $0.trackerID == tracker.id
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackersCollectionViewCell
        cell.emojiLabel.text = "🍉"
        cell.titleLabel.text = "первый трекер"
        cell.daysLabel.text = "1 день"
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9)/2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 9
    }
}
