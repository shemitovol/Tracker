import CoreData

final class TrackerRecordStore: NSObject {
    //MARK: - Public Properties
    weak var delegate: TrackerRecordStoreDelegate?
    
    //MARK: - Private Properties
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: false) ]

        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("TrackerRecordStore fetch error: \(error)")
        }
        return frc
    }()
    
    //MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        _ = fetchedResultsController
    }
    
    //MARK: - Public Methods
    func addRecord(trackerID: UUID, date: Date) throws {
        let request = TrackerCoreData.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        guard let tracker = try context.fetch(request).first else {
            throw NSError(domain: "TrackerRecordStore",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Трекер не найден"])
        }
        
        let record = TrackerRecordCoreData(context: context)
        record.date = Calendar.current.startOfDay(for: date)
        record.tracker = tracker
        try context.save()
    }
    
    func deleteRecord(trackerID: UUID, date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date == %@",
            trackerID as CVarArg,
            Calendar.current.startOfDay(for: date) as NSDate
        )
        
        let records = try context.fetch(request)
        records.forEach {
            context.delete($0)
        }
        try context.save()
    }
    
    func isCompleted(trackerID: UUID, date: Date) throws -> Bool {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date == %@",
            trackerID as CVarArg,
            Calendar.current.startOfDay(for: date) as NSDate
        )
        return try context.count(for: request) > 0
    }
    
    func completedCount(trackerID: UUID) throws -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@",
            trackerID as CVarArg
        )
        return try context.count(for: request)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
