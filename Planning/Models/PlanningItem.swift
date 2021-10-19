
import Foundation



struct PlanningItem
{
    let task: Task
    let startDate: Date
    let duration: TimeInterval
    var endDate: Date { self.startDate.addingTimeInterval(self.duration) }
}
