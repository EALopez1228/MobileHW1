//
//  ClaimService.swift
//  RestServer
//
//  Created by Emilio Lopez on 10/24/20.
//

import SQLite3
import Foundation

struct Claim : Codable {
    var id : String?
    var title : String?
    var date : String?
    var solved : Bool?
    
    init(i : String?, t : String?, d : String?, s : Bool?) {
        if i == "" {
            let uuid = UUID().uuidString
            id = uuid
        }
        else {
            id = i
        }
        title = t
        date = d
        solved = s
    }
}

class ClaimsFunctions {
    
    func addClaim(cObj : Claim) {
        let sqlStmt = String(format:"insert into Claims (ID, Title, Date, isSolved) values ('%@', '%@', '%@, '%@')", (cObj.id)!, (cObj.title)!, (cObj.date)!, (cObj.solved)!)
        let conn = Database.getInstance().getDbConnection()
        
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Person record due to error \(errcode)")
        }
        
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        
        var claimList = [Claim]()
        var result : OpaquePointer?
        let sqlStr = "select first_name, last_name, ssn from person"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &result, nil) == SQLITE_OK {
            while(sqlite3_step(result) == SQLITE_ROW) {
                // Convert the record into a Person object
                // Unsafe_Pointer<CChar> Sqlite3
                let id_val = sqlite3_column_text(result, 0)
                let id = String(cString: id_val!)
                let title_val = sqlite3_column_text(result, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(result, 2)
                let date = String(cString: date_val!)
                let solved_val = sqlite3_column_text(result, 3)
                let solved = Bool(String(cString: solved_val!))
                
                claimList.append(Claim(i:id, t:title, d:date, s:solved))
            }
        }
        return claimList
        
    }
}
