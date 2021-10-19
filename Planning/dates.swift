
import Foundation



extension Date
{
    static func tomorrow(at hours: Int, minutes: Int) -> Date {
        
        let now = Date()
        
        let sameTimeTomorrow = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
        
        let tomorrowAt = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: sameTimeTomorrow)!
        
        return tomorrowAt
    }
}
