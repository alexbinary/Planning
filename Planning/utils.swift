
import Foundation



func readApplicationData(from url: URL) -> ApplicationDataContainer {
    
    return (try? JSONDecoder().decode(ApplicationDataContainer.self, from: Data(contentsOf: url))) ?? ApplicationDataContainer(planning: Planning(taskSchedulings: []), backlog: Backlog(tasks: []))
}

func save(_ appDataContainer: ApplicationDataContainer, to url: URL) {
    
    try! JSONEncoder().encode(appDataContainer).write(to: url)
}
