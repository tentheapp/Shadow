//
//  Requests_API.swift
//  Shadow
//
//  Created by Aditi on 29/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import Foundation

class Requests_API: NSObject {
    
    static let sharedInstance = Requests_API()
    
    typealias completionHandler = (_ status:NSNumber,_ dictionary:NSDictionary)-> Void
    typealias completion_Handler = (_ status:NSNumber,_ array:NSArray)-> Void

    typealias ErrorBlock = (NSError?)->Void


    
    func sendRequest(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                if response?["data"] != nil{
                let dict_Info = ((response as! NSDictionary).value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                completionBlock(status!,dict_Info)
                }
            }
            else
            {
                completionBlock(status!,[:])

            }
            
        }, error_block: {(err) in
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "sendRequest")
        
    }
    
    func getRequestByType(completionBlock:@escaping completion_Handler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                let array_Info = ((response as! NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                completionBlock(status!,array_Info)
            }
            else
            {
                completionBlock(status!,[])
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getRequestByType")
        
    }
    
    func deleteRequests(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                //let dict_Info = ((response as! NSDictionary).value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                completionBlock(status!,[:])
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "deleteRejectRequest")
    }
    
    
    func requestAcceptReject(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary){
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                let dict_Info = ((response as! NSDictionary).value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                completionBlock(status!,dict_Info)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
            
        }, paramDict: dict, is_synchronous: false, url:"acceptRejectRequest")
        
    }
    
    
    
    
    
    func viewRequest(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dictionary:NSMutableDictionary)  {
        
          ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                let dict_Info = ((response as! NSDictionary).value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                completionBlock(status!,dict_Info)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
          }, error_block: {
            (error) in
            
            errorBlock(error)
            
          }, paramDict: dictionary, is_synchronous: false, url: "viewRequest")
     }
    

    
    
    // for super admin home screen
    func getTopThreeUserListForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,response as! NSDictionary)
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getTopThreeUserListForSuperAdmin")
    }
    
    // for super admin home screen (see more)
    func getAllVerifiedUserByTypeForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,response as! NSDictionary)
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllVerifiedUserByTypeForSuperAdmin")
    }

    // for super admin pending request for school and company
    
    func getAllPendingUserByTypeForSuperAdmin(completionBlock:@escaping completion_Handler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                let array_Info = ((response as! NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                completionBlock(status!,array_Info)
            }
            else
            {
                completionBlock(status!,[])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllPendingUserByTypeForSuperAdmin")
    }
    
    
    // for company home page
    func getTopUserAndCountForCompanyAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getTopUserAndCountForCompanyAdmin")
  
    }
    
    //getTopUserAndCountForSchoolAdmin
    func getTopUserAndCountForSchoolAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getTopUserAndCountForSchoolAdmin")
        
    }
    
    

    
    //getAllVerifiedUserForCompanyAdmin
    func getAllVerifiedUserForCompanyAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllVerifiedUserForCompanyAdmin")
    }

    //getAllPendingUserListForCompanyAdmin
    func getAllPendingUserListForCompanyAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllPendingUserListForCompanyAdmin")
    }

    //getAllPendingUserListForSchoolAdmin
    func getAllPendingUserListForSchoolAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllPendingUserListForSchoolAdmin")
    }
    
    
    //getAllVerifiedUserListForSchoolAdmin
    func getAllVerifiedUserListForSchoolAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllVerifiedUserListForSchoolAdmin")
    }
    
    
    
    //updateUserVerificationByType
    func updateUserVerificationByType(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "updateUserVerificationByType")
    }
    
    //blockUserByTypeForSuperAdmin
    func blockUserByTypeForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "blockUserByTypeForSuperAdmin")
    }
    
    
    //unBlockUserByTypeForSuperAdmin
    func unBlockUserByTypeForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "unBlockUserByTypeForSuperAdmin")
    }
    
   //deleteUserByTypeForSuperAdmin
    func deleteUserByTypeForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "deleteUserByTypeForSuperAdmin")
    }

    
    
    
    func searchFilter(completionBlock:@escaping completion_Handler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                let array_Info = ((response as! NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                completionBlock(status!,array_Info)
            }
            else
            {
                completionBlock(status!,[])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "searchFilter")
    }

//getAllUserByTypeForSuperAdmin
    
    func getAllUserByTypeForSuperAdmin(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "getAllUserByTypeForSuperAdmin")
    }
  
  //Save deleted chat ids
    func saveChatArray(completionBlock:@escaping completionHandler,errorBlock:@escaping ErrorBlock,dict:NSMutableDictionary)  {
        
        ServerCall.sharedInstance.postService({ (response) in
            
            let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
            if status == 200
            {
                completionBlock(status!,response as! NSDictionary)
            }
            else
            {
                completionBlock(status!,[:])
                
            }
            
        }, error_block: {(err) in
            
            errorBlock(err)
        }, paramDict: dict, is_synchronous: false, url: "saveChatArray")
    }
    

}
    
