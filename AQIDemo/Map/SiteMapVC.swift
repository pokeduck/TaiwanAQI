//
//  SiteMapVC.swift
//  AQIDemo
//
//  Created by Well.Ku on 2019/6/23.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import MapKit
import SideMenu
import CoreLocation
class SiteMapVC: UIViewController {

    var map: MKMapView!
    var aqis:Aqi? = nil
    var expandRegion:MKCoordinateRegion?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(true)
        setMap()
        setupCompassBtn()
        setupButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdated), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdated), name: kLocalDBDidUpdated, object: nil)
    }
    @objc func didUpdated(){
        loadData(false)
    }
    private func loadData(_ expandRegion:Bool){
        AQIDB.query().done { (eles) in
            self.aqis = eles
            let annos = eles.makeAnnos()
            let r = annos.region
            self.expandRegion = r
            self.addAnnos(annos)
            if expandRegion {
                self.map.setRegion(r, animated: true)
            }
        }.catch { (err) in
            print(err)
        }
    }
    private func addAnnos(_ annos:[MKAnnotation]){
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annos)
    }
    @objc func showNearestSite() {
        let coor = LocationScan.default.currentCoor.coordinate
        let nSite = aqis?.queryWith(with: coor.latitude, lon: coor.longitude).0
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (nSite?.latitude.double)!, longitude: (nSite?.longitude.double)!), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.map.setRegion(region, animated: true)
    }
    @objc func showUserLocation() {
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.map.setRegion(region, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: UI
extension SiteMapVC {
    private func setMap(){
        map = MKMapView(frame: .zero)
        view.addSubview(map)
        map.fill()
        map.delegate = self
        map.showsUserLocation = true
        map.userTrackingMode = .none
        map.showsCompass = false
        map.userLocation.title = ""

        map.register(SiteClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        map.register(StopAnnoView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    private func setupCompassBtn(){
        let cmsBtn = MKCompassButton(mapView: map)
        cmsBtn.compassVisibility = .adaptive
        map.addSubview(cmsBtn)
        cmsBtn.translatesAutoresizingMaskIntoConstraints = false
        let cs = [cmsBtn.rightAnchor.constraint(equalTo: map.rightAnchor, constant: -20),
                  cmsBtn.topAnchor.constraint(equalTo: map.safeAreaLayoutGuide.topAnchor, constant: 20)]
        NSLayoutConstraint.activate(cs)
    }
    private func setupButtons() {
        let trackBtn = MKUserTrackingButton(mapView: map)
        trackBtn.mapStyle()
        map.addSubview(trackBtn)
        trackBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let expandBtn = UIButton(type: .system)
        expandBtn.imageView?.contentMode = .scaleAspectFit
        expandBtn.mapStyle()
        expandBtn.setImage(#imageLiteral(resourceName: "btn-expand"), for: .normal)
        expandBtn.addTarget(self, action: #selector(expand), for: .touchUpInside)
        map.addSubview(expandBtn)
        expandBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let nearBtn = UIButton(type: .system)
        nearBtn.imageView?.contentMode = .scaleAspectFit
        nearBtn.mapStyle()
        nearBtn.setImage(#imageLiteral(resourceName: "btn-site"), for: .normal)
        nearBtn.addTarget(self, action: #selector(near), for: .touchUpInside)
        map.addSubview(nearBtn)
        nearBtn.translatesAutoresizingMaskIntoConstraints = false
       
        let menuBtn = UIButton(type: .system)
        menuBtn.setImage(#imageLiteral(resourceName: "menu-button"), for: .normal)
        menuBtn.mapStyle()
        menuBtn.addTarget(self, action: #selector(menu), for: .touchUpInside)
        map.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackBtn.rightAnchor.constraint(equalTo: map.safeAreaLayoutGuide.rightAnchor, constant: -20),
            trackBtn.bottomAnchor.constraint(equalTo: map.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            trackBtn.widthAnchor.constraint(equalToConstant: 40),
            trackBtn.heightAnchor.constraint(equalToConstant: 40),
            
            nearBtn.bottomAnchor.constraint(equalTo: trackBtn.topAnchor, constant: -20),
            nearBtn.leftAnchor.constraint(equalTo: trackBtn.leftAnchor),
            nearBtn.rightAnchor.constraint(equalTo: trackBtn.rightAnchor),
            nearBtn.heightAnchor.constraint(equalToConstant: 40),
            
            expandBtn.topAnchor.constraint(equalTo: trackBtn.topAnchor),
            expandBtn.bottomAnchor.constraint(equalTo: trackBtn.bottomAnchor),
            expandBtn.rightAnchor.constraint(equalTo: trackBtn.leftAnchor,constant: -20),
            expandBtn.widthAnchor.constraint(equalToConstant: 40),
            
            menuBtn.topAnchor.constraint(equalTo: map.safeAreaLayoutGuide.topAnchor, constant: 20),
            menuBtn.leftAnchor.constraint(equalTo: map.safeAreaLayoutGuide.leftAnchor, constant: 20),
            menuBtn.widthAnchor.constraint(equalToConstant: 40),
            menuBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    @objc func expand(){
        guard let r = self.expandRegion else { return }
        map.setRegion(r, animated: true)
    }
    @objc func near(){
        let coor = map.userLocation.coordinate
        guard let nSite = aqis?.queryWith(with: coor.latitude, lon: coor.longitude).0 else { return }
        let siteCoor = CLLocationCoordinate2D(latitude: nSite.latitude.double, longitude: nSite.longitude.double)
        let r = MKCoordinateRegion(center: siteCoor, latitudinalMeters: 3000.0, longitudinalMeters: 3000.0)
        map.setRegion(r, animated: true)
    }
    @objc func menu(){
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
        
    }
}
extension UIView {
    func mapStyle(){
        tintColor = ThemeColor.systemBlue
        backgroundColor = .white
        layer.opacity = 0.85
        layer.borderColor = ThemeColor.systemBlue.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
}
extension SiteMapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKClusterAnnotation {
            return SiteClusterView(annotation: annotation, reuseIdentifier: SiteClusterView.reuseID)
        }
        if let _ = annotation as? SiteAnno {
            return StopAnnoView(annotation: annotation, reuseIdentifier: StopAnnoView.reuseID)
        }
        if annotation.isKind(of: MKUserLocation.self) {
            let view = mapView.view(for: annotation)
            view?.canShowCallout = false
            return view
        }
        return nil

    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let v = view as? StopAnnoView ,
            let anno = v.annotation as? SiteAnno
            {
            guard let ele = aqis?.query(with: anno.siteID) else { return }
            self.present(DetailCollVC(with: ele,topViewStyle: .add,backgroundColor: .blue), animated: true, completion: nil)
            mapView.deselectAnnotation(anno, animated: true)
            return
        }
        if let v = view as? SiteClusterView {
            guard let cluster = v.annotation as? MKClusterAnnotation,
                let sites:[SiteAnno] = cluster.memberAnnotations as? [SiteAnno]
                else {return}
            mapView.setRegion(sites.region, animated: true)
            return
        }
        

    }
}

