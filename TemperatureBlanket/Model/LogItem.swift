import Foundation
import os.log

class LogItem: Codable {
    // depreciated
    let date: String!
    let weatherString: String!
    
    public var description: String {
        return "LogItem: \(String(describing: date)), \(String(describing: weatherString))"
    }
    
    private enum CodingKeys: String, CodingKey {
        case date
        case weatherString
    }
    
    //MARK: Archiving Paths
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("logs")
    
    init(weather: WeatherResponse) {
        self.date = NSDate.now.description(with: Locale(identifier: "en_US"))
        
        let fTemp = Double(round(100*(Main.kelvinToF(kel: (weather.main?.temp)!)))/100) // round to 2 decimal places
        let desc = weather.weather[0]?.main
        self.weatherString = "\(fTemp)°F, \(desc ?? "ERROR")"
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(date, forKey: .date)
      try container.encode(weatherString, forKey: .weatherString)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.weatherString = try container.decode(String.self, forKey: .weatherString)
    }
}

class Year: Codable {
    // has 52 weeks
    // well technically +1 day but we have until the end of the year to account for that and we're on a time limit here
    
    var weeks: [Week]
    
    init() {
        weeks = Array(repeating: Week(), count: 52)
    }
    
    var isFull: Bool {
        if let ind = indexOfLastDay() {
            return ind == (51, 6)
        }
        return false
    }
    
    func dayFromInd(ind: (Int, Int)) -> Day? {
        if ind.1 >= self.weeks[ind.0].days.count {
            return nil
        }
        return self.weeks[ind.0].days[ind.1]
    }
    
    func indexOfEmpty() -> (Int, Int)? {
        guard let firstEmptyWeek = weeks.firstIndex(where: { !$0.full }) else {
            print("The calendar is full.")
            return nil
        }
        let firstEmptyDay = weeks[firstEmptyWeek].days.count
        
        print("The first not-full week is Week \(firstEmptyWeek), of which Day \(firstEmptyDay) does not exist.")
        return (firstEmptyWeek, firstEmptyDay)
    }
    
    func indexOfLastDay() -> (Int, Int)? {
        // this isn't elegant but it should work
        guard var lastRecordedWeek = weeks.firstIndex(where: { !$0.full }) else {
            print("The calendar is full.")
            return (51, 6) // the last day of the year
        }
        var lastRecordedDay = weeks[lastRecordedWeek].days.count - 1
        
        if lastRecordedDay < 0 {
            // the last day of the previous week
            lastRecordedDay = 6
            lastRecordedWeek -= 1
        }
        
        if lastRecordedWeek < 0 {
            print("The calendar is empty.")
            return nil
        }
        
        print("The last recorded day is Week \(lastRecordedWeek), Day \(lastRecordedDay).")
        return (lastRecordedWeek, lastRecordedDay)
    }
    
    func isCaughtUp(cal: Calendar) -> Bool {
        if let ind = indexOfLastDay() {
            // calendar is full or recorded up to yesterday
            return ( ind == (51, 6) || self.weeks[ind.0].days[ind.1].isYesterday(cal: cal) )
        }
        // if calendar is empty, it is by default not caught up
        // (the first of the year has already passed, but this should be adjusted for next year)
        return false
    }
    
    func addDay(week: Int, date: Date, api: DayInTimeResponse, completed: Bool=false) {
        print("Adding day to week \(week).")
        if week >= 0 && week < 52 {
            self.weeks[week].addDay(date: date, api: api, completed: completed)
            print("With new day, week looks like this: \(self.weeks[week])")
        }
    }
}

class Week: Codable {
    // has (up to) 7 days
    var days: [Day]
    var full: Bool {
        return days.count >= 7
    }
    
    init() {
        days = []
    }
    
    func addDay(date: Date, api: DayInTimeResponse, completed: Bool=false) {
        if self.full {
            print("Attempted to add a day to a full week. Operation skipped for date: \(date)")
            return
        }
        let day = Day(date: date, dayResponse: api, complete: completed)
        self.days.append(day)
        print("Appended day \(day).")
    }
}

class Day: Codable {
    // has a date object and some relevant info
    let date: Date
    let temp: Int
    var complete: Bool
    
    init(date: Date, temp: Int, complete: Bool=false) {
        self.date = date
        self.temp = temp
        self.complete = complete
    }
    
    convenience init(date: Date, dayResponse: DayInTimeResponse, complete: Bool=false) {
        
        let hours = dayResponse.hourly.hours
        var avgs: [Int] = []
        for hour in hours {
            avgs.append(Int(hour.temperature))
        }
        let sum = avgs.reduce(0, +)
        
        // temp is approximate average temp throughout the day
        self.init(date: date, temp: sum / avgs.count, complete: complete)
    }
    
    func isToday(cal: Calendar) -> Bool {
        return cal.isDateInToday(self.date)
    }
    
    func isYesterday(cal: Calendar) -> Bool {
        return cal.isDateInYesterday(self.date)
    }
}
