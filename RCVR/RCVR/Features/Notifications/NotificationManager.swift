//
//  NotificationManager.swift
//  RCVR
//
//  Created by richard Haynes on 5/6/24.
//

import Foundation
import UserNotifications
final class NotificationManager: Observable {
    
    func requestNotificationAuthorization(){
        // Badge is the red numerical icon that displays over apps needing attention
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options){
            (success, error) in
            if let error = error {
                print(error)
            }
            else {
                print("Notficications Approved")
            }
        }
    }
    
    func scheduleNotifications(from date : Date, id : UUID, subTitle: String = "Time For You To RCVR"){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "RCVR Time"
        notificationContent.subtitle = subTitle
        notificationContent.sound = .default
        notificationContent.badge = 1
        let components : DateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: id.uuidString, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest)
    }
    
    func removeNotification(id: String?){
        guard let id = id else {
            return
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func resetBadge() async {
        let center = UNUserNotificationCenter.current()
        do {
             try await center.setBadgeCount(0)
        } catch {
             print("Failed to reset badge count")
        }
    }
}
