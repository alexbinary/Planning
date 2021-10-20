
import XCTest
@testable import Planning



class PrinterTest: XCTestCase {

    
    func test_makeEmptyEntryPrintModel() {
        
        let timeSlot = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
        
        let printer = Printer()
        let model = printer.makeEmptyEntryPrintModel(on: timeSlot)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "(Empty)")
        XCTAssertEqual(model.title, "Empty")
        XCTAssertEqual(model.subtitle, nil)
        XCTAssertEqual(model.extra, nil)
    }
    
    
    func test_makeEntryPrintModelFrom() {
        
        let task = Task(withName: "t1")
        let timeSlot = TimeSlot(between: Date(timeIntervalSinceReferenceDate: 0), and: Date(timeIntervalSinceReferenceDate: 1))
        let entry = PlanningEntry(withTask: task, on: timeSlot)
        
        let printer = Printer()
        let model = printer.makeEntryPrintModel(from: entry)
        
        XCTAssertEqual(model.timeSlot, timeSlot)
        XCTAssertEqual(model.head, "\(entry.id)")
        XCTAssertEqual(model.title, "\(task.id)")
        XCTAssertEqual(model.subtitle, "\(task.name)")
        XCTAssertEqual(model.extra, "Feedback: \(entry.feedback?.description ?? "-")")
    }
    
    
    func test_planningEntryPrintModelsFrom_continuous() {
        
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 4), duration: 2))
        let entry3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 6), duration: 2))
        
        let printer = Printer()
        let models = printer.planningEntryPrintModels(from: dataModel)
        
        XCTAssertEqual(models, [
            printer.makeEntryPrintModel(from: entry1),
            printer.makeEntryPrintModel(from: entry2),
            printer.makeEntryPrintModel(from: entry3),
        ])
    }
    
    
    func test_planningEntryPrintModelsFrom_holes() {
        
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate:  2), duration: 2))
        let entry2 = dataModel.addToPlanning(Task(withName: "t2"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate:  6), duration: 2))
        let entry3 = dataModel.addToPlanning(Task(withName: "t3"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 10), duration: 2))
        
        let printer = Printer()
        let models = printer.planningEntryPrintModels(from: dataModel)
        
        XCTAssertEqual(models, [
            printer.makeEntryPrintModel(from: entry1),
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: entry1.timeSlot.endDate, and: entry2.timeSlot.startDate)),
            printer.makeEntryPrintModel(from: entry2),
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: entry2.timeSlot.endDate, and: entry3.timeSlot.startDate)),
            printer.makeEntryPrintModel(from: entry3),
        ])
    }
    
    
    func test_planningEntryPrintModelsFromOn_emptyStart() {
        
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 3)
        let models = printer.planningEntryPrintModels(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: timeSlot.startDate, and: entry1.timeSlot.startDate)),
            printer.makeEntryPrintModel(from: entry1),
        ])
    }
    
    
    func test_planningEntryPrintModelsFromOn_emptyEnd() {
        
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 3), duration: 2)
        let models = printer.planningEntryPrintModels(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeEntryPrintModel(from: entry1),
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: entry1.timeSlot.endDate, and: timeSlot.endDate)),
        ])
    }
    
    
    func test_planningEntryPrintModelsFromOn_emptyStartAndEnd() {
        
        var dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let entry1 = dataModel.addToPlanning(Task(withName: "t1"), on: TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 2), duration: 2))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 5)
        let models = printer.planningEntryPrintModels(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: timeSlot.startDate, and: entry1.timeSlot.startDate)),
            printer.makeEntryPrintModel(from: entry1),
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: entry1.timeSlot.endDate, and: timeSlot.endDate)),
        ])
    }
    
    
    func test_planningEntryPrintModelsFromOn_noEntries() {
        
        let dataModel = DataModel(planning: Planning(entries: []), backlog: Backlog(tasks: []))
        
        let printer = Printer()
        let timeSlot = TimeSlot(withStartDate: Date(timeIntervalSinceReferenceDate: 1), duration: 5)
        let models = printer.planningEntryPrintModels(from: dataModel, on: timeSlot)
        
        XCTAssertEqual(models, [
            printer.makeEmptyEntryPrintModel(on: TimeSlot(between: timeSlot.startDate, and: timeSlot.endDate)),
        ])
    }
}
