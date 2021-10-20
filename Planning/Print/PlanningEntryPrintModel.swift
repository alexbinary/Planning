
import Foundation



struct PlanningEntryPrintModel: Equatable
{
    let timeSlot: TimeSlot
    let head: String
    let title: String
    let subtitle: String?
    let extra: String?
}
