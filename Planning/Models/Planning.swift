
import Foundation



struct Planning: Codable
{
    var taskSchedulings: [TaskScheduling]
    
    var mostRecentTaskSchedulingEndDate: Date? { self.taskSchedulings.max(by: { $0.timeSlot.endDate < $1.timeSlot.endDate })?.timeSlot.endDate }
}
