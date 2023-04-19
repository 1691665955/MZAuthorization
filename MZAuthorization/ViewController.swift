//
//  ViewController.swift
//  MZAuthorization
//
//  Created by 曾龙 on 2022/7/4.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getAuth(_ sender: Any) {
        MZAuthorization.requestAuth(type: .bluetooth) {
            print("蓝牙权限打开成功")
        }
        
        //        MZAuthorization.requestAuth(type: .camera) {
        //            print("相机权限打开成功")
        //        }
        
        //        MZAuthorization.requestAuth(type: .mic) {
        //            print("麦克风权限打开成功")
        //        }
        
        //        MZAuthorization.requestAuth(type: .photoReadWrite) {
        //            print("相册选择权限打开成功")
        //
        //            // 使用该方法保存图片需请求读取写入权限（photoReadWrite）
        //            MZPhotoAsset.saveImage(image: UIImage.init(named: "1")!, collectionName: "MZAuthorization") { success in
        //                print(success ? "保存成功" : "保存失败")
        //            }
        //        }
        
        //        MZAuthorization.requestAuth(type: .photoAddOnly) {
        //            print("相册添加权限打开成功")
        //
        //            // 使用该方法保存图片只需请求写入权限（photoAddOnly）
        //            UIImageWriteToSavedPhotosAlbum(UIImage.init(named: "1")!, self, #selector(self.didFinishSavingImage(image:error:contextInfo:)), nil)
        //        }
        
        //        MZAuthorization.requestAuth(type: .contact) {
        //            print("通讯录权限打开成功")
        //        }
        
        //        MZAuthorization.requestAuth(type: .event) {
        //            print("日历权限打开成功")
        //        }
        
        //        MZAuthorization.requestAuth(type: .reminder) {
        //            print("提醒权限打开成功")
        //        }
        
        //        // 获取定位
        //        MZAuthorization.requestAuth(type: .locationWhenInUse) {
        //            print("定位权限打开成功")
        //        } failure: {
        //            print("请打开定位")
        //        }
        
        //        // 后台获取定位
        //        MZAuthorization.requestAuth(type: .locationAlways) {
        //            print("定位权限打开成功")
        //
        //            self.locationManager = CLLocationManager()
        //            self.locationManager?.delegate  = self
        //            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //            self.locationManager?.allowsBackgroundLocationUpdates = true
        //            self.locationManager?.startUpdatingLocation()
        //        } failure: {
        //            print("请打开定位")
        //        }
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations.first?.coordinate.latitude ?? 0.0)")
    }
    
    //MARK: -
    @objc func didFinishSavingImage(image: UIImage, error: NSError?, contextInfo: UnsafeRawPointer?) {
        guard let error = error else {
            print("Save imag succeed.")
            return
        }
        print("Save image failed with error \(error)")
    }
}
