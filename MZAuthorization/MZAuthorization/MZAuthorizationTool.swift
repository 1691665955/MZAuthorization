//
//  MZAuthorizationTool.swift
//  MZAuthorization
//
//  Created by 曾龙 on 2022/7/4.
//

import UIKit
import Photos
import AVFoundation
import Contacts
import EventKit

public enum MZAuthorizationStatus: Int {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
    case limited = 4
    case disable = 5
}

public enum KPhotoAccessLevel: Int {
    case addOnly = 1
    case readWrite = 2
}

public enum KLocationAuthLevel: Int {
    case whenInUse = 1
    case always = 2
}

public class MZAuthorizationTool: NSObject, CLLocationManagerDelegate {
    
    private static let instance: MZAuthorizationTool = MZAuthorizationTool()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    //MARK: - 获取权限状态
    
    /// 获取相册权限状态
    /// - Parameter level: 权限等级
    /// - Returns: 权限状态
    public static func photoAuthorizationStatus(level: KPhotoAccessLevel = .readWrite) -> MZAuthorizationStatus {
        var status: PHAuthorizationStatus!
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: level == .addOnly ? .addOnly : .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取相机权限状态
    /// - Returns: 权限状态
    public static func cameraAuthorizationStatus() -> MZAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取麦克风权限状态
    /// - Returns: 权限状态
    public static func micAuthorizationStatus() -> MZAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取通讯录权限状态
    /// - Returns: 权限状态
    public static func contactAuthorizationStatus() -> MZAuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取日历权限状态
    /// - Parameter type: 权限类型
    /// - Returns: 权限状态
    public static func calendarAuthorizationStatus(type: EKEntityType) -> MZAuthorizationStatus {
        let status = EKEventStore.authorizationStatus(for: type)
        return MZAuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// 获取定位权限状态
    /// - Returns: 权限状态
    public static func locationAuthorizationStatus() -> MZAuthorizationStatus {
        if !CLLocationManager.locationServicesEnabled() {
            return .disable
        }
        
        var status: CLAuthorizationStatus = .denied
        if #available(iOS 14.0, *) {
            let locationManager =  CLLocationManager()
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        status = CLLocationManager.authorizationStatus()
        return MZAuthorizationStatus.init(rawValue: Int(status.rawValue)) ?? .denied
    }
    
    /// 获取推送权限状态
    /// - Returns: 权限状态
    public static func notificationAuthorizationStatus() -> MZAuthorizationStatus {
        if #available(iOS 10.0, *) {
            var status: MZAuthorizationStatus = .denied
            let sema = DispatchSemaphore(value: 0)
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                status = MZAuthorizationStatus.init(rawValue: settings.authorizationStatus.rawValue) ?? .denied
                sema.signal()
            }
            sema.wait()
            return status
        } else {
            let types = UIApplication.shared.currentUserNotificationSettings?.types
            if types == UIUserNotificationType.init(rawValue: 0) {
                return .denied
            } else {
                return .authorized
            }
        }
    }
    
    //MARK: - 获取权限授权
    
    
    /// 获取相册授权
    /// - Parameters:
    ///   - level: 权限等级
    ///   - completionHandler: 授权回调
    public static func requestPhotoAuthorization(level: KPhotoAccessLevel = .readWrite, completionHandler: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: level == .addOnly ? .addOnly : .readWrite) { status in
                completionHandler(status == .authorized)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                completionHandler(status == .authorized)
            }
        }
    }
    
    /// 获取相机授权
    /// - Parameter completionHandler: 授权回调
    public static func requsetCameraAuthorization(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completionHandler)
    }
    
    /// 获取麦克风授权
    /// - Parameter completionHandler: 授权回调
    public static func requestMicAuthorization(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: completionHandler)
    }
    
    /// 获取通讯录授权
    /// - Parameter completionHandler: 授权回调
    public static func requestContactAuthorization(completionHandler: @escaping (Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            if error == nil {
                completionHandler(granted)
            } else {
                completionHandler(false)
            }
        }
    }
    
    /// 获取日历授权
    /// - Parameters:
    ///   - type: 授权类型
    ///   - completionHandler: 授权回调
    public static func requestCalendarAuthorization(type: EKEntityType, completionHandler: @escaping (Bool) -> Void) {
        EKEventStore().requestAccess(to: type) { granted, error in
            if error == nil {
                completionHandler(granted)
            } else {
                completionHandler(false)
            }
        }
    }
    
    /// 获取定位授权
    /// - Parameters:
    ///   - level: 授权等级
    ///   - completionHandler: 授权回调
    public static func requestLocationAuthorization(level: KLocationAuthLevel, completionHandler: @escaping (Bool) -> Void) {
        if level == .whenInUse {
            instance.locationManager.requestWhenInUseAuthorization()
        } else {
            instance.locationManager.allowsBackgroundLocationUpdates = true
            instance.locationManager.requestAlwaysAuthorization()
        }
    }
    
}
