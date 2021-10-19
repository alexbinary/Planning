
import Foundation



struct Planning: Codable
{
    var entries: [PlanningEntry]
    
    var mostRecentEntryEndDate: Date? { self.entries.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })?.timeSlot.endDate }
}
