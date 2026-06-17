import CoreData

final class TrackerCategoryStore: NSObject {
    //MARK: - Public Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    
    //MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    //MARK: - Initialization
    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
        super.init()
        _ = fetchedResultsController
    }
    
    //MARK: - Public Methods
    func addCategoryIfNeeded(title: String) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let existing = try context.fetch(request).first {
            return existing
        }
        
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        try context.save()
        return category
    }
    
    func fetchCategories() -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.map(makeCategory)
    }
    
    //MARK: - Private Methods
    private func makeCategory(from categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            fatalError("Category title is nil")
        }
        let trackers = (categoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.map {trackerStore.makeTracker(from: $0)} ?? []
        return TrackerCategory(title: title, trackers: trackers)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
