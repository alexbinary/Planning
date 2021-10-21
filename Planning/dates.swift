
import Foundation



extension Date
{
    
    /// Returns the current date.
    ///
    static var now: Date { Date() }
    
    
    /// Returns a date that is set at the given hours and minutes the next day from the current day.
    ///
    static func tomorrow(at hours: Int, minutes: Int) -> Date {
        
        let now = Date()
        
        let sameTimeTomorrow = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
        
        let tomorrowAt = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: sameTimeTomorrow)!
        
        return tomorrowAt
    }
}
