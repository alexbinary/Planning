
import Foundation



struct Task: Codable
{
    let id: UUID
    let name: String
    
    init(withName name: String) {
        
        self.id = UUID()
        self.name = name
    }
}
