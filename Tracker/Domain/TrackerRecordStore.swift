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
            assertionFailure("Couln't load categories from CoreData")
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
            assertionFailure("Couln't delete tracker records from CoreData")
        }
        recordRequest.predicate = nil
    }
    
    func loadCompletedTrackers() -> Set<TrackerRecord> {
        var records: Set<TrackerRecord> = []
        var recordsFromStorage: [TrackerRecordCD] = []
        
        do {
            recordsFromStorage = try context.fetch(recordRequest)
        }
        catch {
            assertionFailure("Couln't load categories from CoreData")
        }
        for recordCD in recordsFromStorage {
            records.insert(TrackerRecord(
                id: Int(recordCD.trackerID),
                date: recordCD.date ?? Date()
            ))
        }
        return records
    }
    
    func saveCompletedTrackers(completedTrackers: Set<TrackerRecord>) {
        for completedTracker in completedTrackers {
            addRecordToCompleted(id: completedTracker.id, date: completedTracker.date)
        }
        removeRecordFromCompleted(completedTrackers: completedTrackers)
    }
    
    func addRecordToCompleted(id: Int, date: Date) {
        recordRequest.predicate = NSPredicate(format: "trackerID == %d AND date == %@", Int64(id), date as CVarArg)
        do {
            let recordFromStorage = try context.fetch(recordRequest)
            if recordFromStorage.isEmpty {
                let newRecord = TrackerRecordCD(context: context)
                newRecord.trackerID = Int64(id)
                newRecord.date = date.withoutTime()
            }
            try context.save()
        }
        catch {
            assertionFailure("Couln't save completed trackers to CoreData")
        }
        recordRequest.predicate = nil
    }

    func removeRecordFromCompleted(completedTrackers: Set<TrackerRecord>) {
        do {
            let recordsFromStorage = try context.fetch(recordRequest)
            for recordCD in recordsFromStorage {
                let record = TrackerRecord(
                    id: Int(recordCD.trackerID),
                    date: recordCD.date ?? Date()
                )
                if !completedTrackers.contains(record) {
                    context.delete(recordCD)
                }
            }
        }
        catch {
            assertionFailure("Couln't remove record from CoreData")
        }
    }
}
