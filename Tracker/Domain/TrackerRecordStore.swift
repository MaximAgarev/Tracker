import Foundation
import CoreData

final class TrackerRecordStore {
    
    let storage = TrackerStorageCoreData.shared
    let recordRequest = TrackerRecordCD.fetchRequest()
    var context: NSManagedObjectContext
    
    init() {
        context = storage.context
    }
    
    func checkRecordExists(trackerID: Int, date: Date) -> Bool {
        var recordsFromStorage: [TrackerRecordCD] = []
        do {
            recordsFromStorage = try context.fetch(recordRequest)
        }
        catch {
            assertionFailure("Couln't load categories from CoreData!")
        }

        let recordExists = recordsFromStorage.contains(where: { record in
            record.date == date.withoutTime() &&
            record.trackerID == trackerID
        })
        
        return recordExists
    }
    
    func removeDeletedTrackerRecords(id: Int64) {
        recordRequest.predicate = NSPredicate(format: "trackerID == %d", id)
        do {
            let recordsFromStorage = try context.fetch(recordRequest)
            recordsFromStorage.forEach { record in
                context.delete(record)
            }
            try context.save()
        }
        catch {
            assertionFailure("Couln't delete tracker records from CoreData!")
        }
        recordRequest.predicate = nil
    }
}
