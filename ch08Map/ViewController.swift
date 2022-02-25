//
//  ViewController.swift
//  ch08Map
//
//  Created by 김규리 on 2022/01/19.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    // 델리게이트
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 델리게이트
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도 설정
        locationManager.requestWhenInUseAuthorization() // 위치 데이터 사용자 승인
        locationManager.startUpdatingLocation() // 위치 업데이트
        myMap.showsUserLocation = true
        //
        
    }
    
    // 위도 경도로 위치 찾기
    // 지도에 원하는 위치를 표시해주는 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue) // 위도 경도 값을 함수에 넣어 리턴값을 pLocation에 저장
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) // 범위 값을 span으로 함수 호출해 spanValue에 저장
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue) // pLocation과 spanValue값을 함수에 넣어 pRegion에 저장
        myMap.setRegion(pRegion, animated: true) //pRegion으로 함수 호출
        
        return pLocation
    }
    
    
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span : Double, title strTitle: String, subtitle strSubtitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    // 위치가 업데이트 되었을 때 지도에 위치를 나타내는 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last // 마지막 위치 값 찾아냄
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01) // delta 값이 작을 수록 확대, 마지막 위치의 위도 경도 값으로 goLocation함수 호출
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first // placemarks 값의 첫 부분만 pm 상수로 대입
            let country = pm!.country // pm 상수에서 나라 값을 country에 대입
            var address:String = country! // // address에 country 대입
            if pm!.locality != nil { // pm의 지역 값이 존재하면
                address += " "
                address += pm!.locality! // address에 추가
            }
            if pm!.thoroughfare != nil { // pm의 도로 값이 존재하면
                address += " "
                address += pm!.thoroughfare! // address에 추가
            }
            
            self.lblLocationInfo1.text = "현재 위치" // 레이블 표시
            self.lblLocationInfo2.text = address // 레이블 표시
            
        })
        
        locationManager.stopUpdatingLocation() // 위치가 업데이트 되는 것을 멈춤
    }
    

    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 현재위치 표시
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.stopUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            // 폴리텍대학 표시
            setAnnotation(latitudeValue: 37.751813, longitudeValue: 128.87605740000004, delta: 1, title: "한국폴리텍대학 강릉캠퍼스", subtitle: "강원도 강릉시 남산초교길 121")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "한국폴리텍대학 강릉캠퍼스"
        } else if sender.selectedSegmentIndex == 2 {
            // 이지스퍼블리싱 표시
            setAnnotation(latitudeValue: 37.556876, longitudeValue: 126.914066, delta: 0.1, title: "이지스퍼블리싱", subtitle: "서울시 마포구 잔다리로 109 이지스 빌딩")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "이지스퍼블리싱 출판사"
        } else if sender.selectedSegmentIndex == 3 {
            // 이지스퍼블리싱 표시
            setAnnotation(latitudeValue: 37.74266, longitudeValue: 126.50311, delta: 0.1, title: "우리집", subtitle: "인천광역시 강화군 강화읍 강화대로 234-12")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "우리집"
        }
        
    }

}

