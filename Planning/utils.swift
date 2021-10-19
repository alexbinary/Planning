
import Foundation



func readDataModel(from url: URL) -> DataModel {
    
    return (try? JSONDecoder().decode(DataModel.self, from: Data(contentsOf: url))) ?? DataModel(planning: Planning(items: []), backlog: Backlog(tasks: []))
}

func save(_ dataModel: DataModel, to url: URL) {
    
    try! JSONEncoder().encode(dataModel).write(to: url)
}
