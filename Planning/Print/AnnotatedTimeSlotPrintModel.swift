
import Foundation



/// A type that stores the data that should be presented to the user to communicate a time slot with associated data.
///
struct AnnotatedTimeSlotPrintModel: Equatable
{
    
    /// The time slot that should be printed.
    ///
    let timeSlot: TimeSlot
    
    
    /// A header text.
    ///
    /// Use this to communicate data that refer to the time slot as a whole.
    ///
    let head: String
    
    
    /// A title text.
    ///
    /// Use this to communicate data that is the main focus point amongst the data associated with the time slot.
    ///
    let title: String
    
    
    /// A subtitle text.
    ///
    /// Use this to communicate data of minor importance.
    ///
    let subtitle: String?
    
    
    /// An extra text
    ///
    /// Use this to communicate any extra data associated with the time slot.
    ///
    let extra: String?
}
