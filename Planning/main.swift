
import Foundation



let dataModel = readDataModel(from: Settings.fileUrl)

print(dataModel)

save(dataModel, to: Settings.fileUrl)
