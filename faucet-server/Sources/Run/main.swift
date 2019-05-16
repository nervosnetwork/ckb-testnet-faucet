import App
import Vapor

if ProcessInfo().arguments[1] == "--save_file_path" {
    if ProcessInfo().arguments.count >= 3 {
        try Export(.detect()).run()
    } else {
        print("Please fill in the path to save the file")
    }
} else {
    try App(.detect()).run()
}
