
import Foundation



extension Date
{
    
    /// Returns a date that can be used as a reference when working with dates.
    ///
    /// The reference date is always the same. The actual date is not important.
    ///
    static var referenceDate: Date { Date(timeIntervalSinceReferenceDate: 0) }
    
    
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
