
import Foundation



let planning = readPlanning(from: Settings.fileUrl)

print(planning)

save(planning, to: Settings.fileUrl)
