import Foundation

//let today = Date.init()
//for i in 0...7 {
//  let nextDate = Calendar.current.date(byAdding: .day, value: i, to: today)
//  let day = Calendar.current.component(.day, from: nextDate!)
//  let weekday = Calendar.current.component(.weekday, from: nextDate!)
//  let month = Calendar.current.component(.month, from: nextDate!)
//  let monthName = DateFormatter().monthSymbols[month - 1]
//  let weekdayName = DateFormatter().weekdaySymbols[weekday - 1]
//  print("Weekday: \(weekdayName) - Day: \(day) - Month: \(monthName)")
//}



func movieEndTime(beginTime: String, duration: Int) -> String {
  if let components = timeComponents(input: beginTime) {
    let tag = components[2]
    var beginHours = Int(components[0])!
    beginHours = tag == "PM" ? (beginHours + 12) : beginHours
    let beginMinutes = Int(components[1])!
 
    let totalMinute = beginMinutes + duration
    var endHours = totalMinute / 60
    let endMinutes = totalMinute - endHours * 60
    endHours += beginHours
    
    if endHours > 12 {
      return "\(endHours - 12):\(endMinutes) PM"
    } else {
      return "\(endHours):\(endMinutes) AM"
    }
  }
  
  return ""
}

func timeComponents(input: String) -> [String]?{
  let regex = try! NSRegularExpression(pattern: "([0-9]{1,2}):([0-9]{1,2})\\s+(AM|PM)")
  let range = NSRange(location: 0, length: input.utf16.count)
  if let firstMatch = regex.firstMatch(in: input, options: [], range: range) {
    var output = [String]()
    for i in 1...3 {
      if let matchedRange = Range(firstMatch.range(at: i), in: input) {
        output.append(String(input[matchedRange]))
      } else {
        return nil
      }
    }
    return output
  }
  
  return nil
}

let string = "2:30 AM"
movieEndTime(beginTime: string, duration: 120)
