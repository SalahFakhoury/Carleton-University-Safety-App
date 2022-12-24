//
//  NotificationService.swift
//  uwbtestapp
//
//  Created by Mohanad Fakhoury on 2022-11-13.
//

import Foundation
import UserNotifications

class NotificationService:NSObject,UNUserNotificationCenterDelegate{
    
    
    
    static let shared = NotificationService()
    private override init(){}
    
    func reguestForAuthorization(){
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            if error != nil {
                // Problem in notifction
            }else{
               // access granted
            }
        }
    }
            
    func createNotifcation(){
        let content = UNMutableNotificationContent()
        content.title = "Safety App"
        content.subtitle = "Critical HAZARD"
        content.sound = UNNotificationSound(named: .init(rawValue: "loud-alarm-tone.mp3")) //UNNotificationSound.default
        
        let tigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let id = "Alert"
        let request = UNNotificationRequest(identifier:id, content: content, trigger: tigger)
        
        UNUserNotificationCenter.current().add(request)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
//            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
}
