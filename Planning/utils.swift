
import Foundation



func readPlanning(from url: URL) -> Planning {
    
    return (try? JSONDecoder().decode(Planning.self, from: Data(contentsOf: url))) ?? Planning(items: [])
}

func save(_ planning: Planning, to url: URL) {
    
    try! JSONEncoder().encode(planning).write(to: url)
}
