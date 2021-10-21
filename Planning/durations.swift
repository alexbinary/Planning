
import Foundation



extension TimeInterval {
    
    
    /// Provides a more readable API to add this duration to another duration.
    ///
    func and(_ duration: TimeInterval) -> TimeInterval {
     
        return self + duration
    }
}



extension Int
{
    
    /// Returns a time interval which uses this number and interprets it as a numer of seconds to set its duration.
    ///
    var seconds: TimeInterval { TimeInterval(self) }
    
    
    /// Returns a time interval which uses this number and interprets it as a numer of minutes to set its duration.
    ///
    var minutes: TimeInterval { Double(self) * 60.seconds }
    
    
    /// Returns a time interval which uses this number and interprets it as a numer of hours to set its duration.
    ///
    var hours: TimeInterval { Double(self) * 60.minutes }
}
