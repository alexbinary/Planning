
import Foundation



struct Planning: Codable
{
    var items: [PlanningItem]
    
    var mostRecentItemEndDate: Date? { self.items.max(by: { $0.endDate < $1.endDate })?.endDate }
}
