
import Foundation



struct Planning: Codable
{
    var entries: [PlanningEntry]
    
    var mostRecentEntryEndDate: Date? { self.entries.max(by: { $0.endDate < $1.endDate })?.endDate }
}
