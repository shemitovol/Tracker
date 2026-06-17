import CoreData
import UIKit

final class TrackerStore: NSObject {
    //MARK: - Public Properties
    weak var delegate: TrackerStoreDelegate?
    
    //MARK: - Private Properties
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]

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
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        _ = fetchedResultsController
    }
    
    //MARK: - Public Methods
    func makeTracker(from trackerCoreData: TrackerCoreData) -> Tracker {
        guard
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let color = trackerCoreData.color as? UIColor,
            let emoji = trackerCoreData.emoji,
            let schedule = trackerCoreData.schedule as? [WeekDay]
        else {
            fatalError("Failed to create Tracker from CoreData")
        }
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }
    
    func addTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.category = category

        try context.save()
    }
    
    func fetchTrackerCoreData(by id: UUID) throws -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        return try context.fetch(request).first
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
