
import Foundation



struct Task: Codable, Equatable
{
    let id: UUID
    let name: String
    
    init(withName name: String) {
        
        self.id = UUID()
        self.name = name
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        return lhs.id == rhs.id
    }
}
