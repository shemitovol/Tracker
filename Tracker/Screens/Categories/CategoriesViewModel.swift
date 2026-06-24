final class CategoriesViewModel {

    // MARK: - Bindings
    var onUpdate: (() -> Void)?
    var onEmptyStateChanged: ((Bool) -> Void)?
    var selectedTitle: String? {
        selectedCategoryTitle
    }

    // MARK: - Private Properties
    private let store: TrackerCategoryStore
    private(set) var categories: [TrackerCategory] = []
    private var selectedCategoryTitle: String?
    
    //MARK: - Initialization
    init(
        store: TrackerCategoryStore,
        selectedTitle: String? = nil
    ) {
        self.store = store
        self.selectedCategoryTitle = selectedTitle
        self.store.delegate = self
    }

    // MARK: - Load

    func load() {
        categories = store.fetchCategories()
        onUpdate?()
        onEmptyStateChanged?(categories.isEmpty)
    }

    // MARK: - Actions

    func addCategory(title: String) {
        do {
            _ = try store.addCategoryIfNeeded(title: title)
        } catch {
            print(error)
        }
    }

    func numberOfRows() -> Int {
        categories.count
    }

    func category(at index: Int) -> TrackerCategory {
        categories[index]
    }

    func selectCategory(at index: Int) -> TrackerCategory {
        let category = categories[index]
        selectedCategoryTitle = category.title
        onUpdate?()
        return category
    }

    // MARK: - State
    private func notifyUpdate() {
        onUpdate?()
        onEmptyStateChanged?(categories.isEmpty)
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        categories = store.fetchCategories()

        onUpdate?()
        onEmptyStateChanged?(categories.isEmpty)
    }
}
