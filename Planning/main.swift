
import Foundation



var dataModel = readDataModel(from: Settings.fileUrl)
save(dataModel, to: Settings.backupFileUrl)

print(dataModel.backlog)
print(dataModel.planning)

// modify backlog or planning...

save(dataModel, to: Settings.fileUrl)
print(Settings.fileUrl)
