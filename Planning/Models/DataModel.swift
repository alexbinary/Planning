
import Foundation



/// A type that stores all the application's data in a single object.
///
/// This type is used to read and write the app's data to and from a file on disk.
///
struct DataModel: Codable
{
   
    /// Stores the planning data.
    ///
    var planning: Planning
    
    
    /// Stores the backlog data.
    ///
    var backlog: Backlog
}
