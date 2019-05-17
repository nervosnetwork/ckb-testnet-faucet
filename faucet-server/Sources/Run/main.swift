import App
import Vapor

print(ProcessInfo.processInfo.arguments[0])
if ProcessInfo.processInfo.arguments[1] == "--save_file_path" {
    if ProcessInfo.processInfo.arguments.count >= 3 {
        try Export(.detect()).run()
    } else {
        print("Please fill in the path to save the file")
    }
} else {
    try App(.detect()).run()
}
