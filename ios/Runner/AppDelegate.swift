import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
  static let methodChannelName = "com.ferris.method_channel"
  static let eventChannelName = "com.ferris.event_channel"
	static let tokenEventChannelName = "com.ferris.token_event_channel"
  static let funcStartService = "start_location_service"
  static let funcResumeService = "resume_location_service"
  static let funcPauseService = "pause_location_service"
  static let funcStopService = "stop_location_service"
  static let funcIsServiceStarted = "is_location_service_started"
  static let funcIsServiceRunning = "is_location_service_running"
  static let funcGetPathNodes = "get_path_nodes"
  static let funcClearPathNodes = "clear_path_nodes"
    
  static let funcSetToken = "set_token"
  static let funcSetJobId = "set_job_id"
  static let funcSetLocationPostUrl = "set_location_post_url"
	
	static let funcGetNewAccessToken = "get_new_access_token"
	static let funcDeleteNewAccessToken = "delete_new_access_token"
    
  static var pathNodes: Array<LocationData> = []
    
	static var newToken: String?
  static var token: String?
  static var jobId: Int?
	static var locationPostUrl: String?
	
	var tokenEventChannel: FlutterEventChannel?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GMSServices.provideAPIKey("AIzaSyAeliVFiosa6wUWV4F_tbF2LcPf2FiFFi4")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let appMethodChannel = FlutterMethodChannel(name: AppDelegate.methodChannelName,
                                              binaryMessenger: controller.binaryMessenger)
    let appEventChannel = FlutterEventChannel(name: AppDelegate.eventChannelName,
                                              binaryMessenger: controller.binaryMessenger)
		tokenEventChannel = FlutterEventChannel(name: AppDelegate.tokenEventChannelName,
																								binaryMessenger: controller.binaryMessenger)
    
    
    appMethodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case AppDelegate.funcStartService:
          let funcResult = self.startService()
          result(funcResult)
          break
        case AppDelegate.funcStopService:
          let funcResult = self.stopService()
          result(funcResult)
          break
        case AppDelegate.funcResumeService:
          let funcResult = self.startTracking()
          result(funcResult)
          break
        case AppDelegate.funcPauseService:
          let funcResult = self.stopTracking()
          result(funcResult)
          break
        case AppDelegate.funcIsServiceStarted:
          let funcResult = self.isServiceStarted()
          result(funcResult)
          break
        case AppDelegate.funcIsServiceRunning:
          let funcResult = self.isTracking()
          result(funcResult)
          break
        case AppDelegate.funcGetPathNodes:
          let funcResult = self.getPathNodes()
          result(funcResult)
          break
        case AppDelegate.funcClearPathNodes:
          let funcResult = self.clearPathNodes()
          result(funcResult)
          break
        case AppDelegate.funcSetToken:
            if let args = call.arguments as? Dictionary<String, Any>,
                let givenToken = args["token"] as? String {
                self.setToken(token: givenToken)
                result(true)
              } else {
                result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              }
          result(true)
          break
        case AppDelegate.funcSetJobId:
            if let args = call.arguments as? Dictionary<String, Any>,
               let givenJobId: Int = args["jobId"] as? Int {
                self.setJobId(jobId: givenJobId)
                result(true)
              } else {
                result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              }
          result(true)
          break
				case AppDelegate.funcSetLocationPostUrl:
					if let args = call.arguments as? Dictionary<String, Any>,
               let url: String = args["location_post_url"] as? String {
                self.setLocationPostUrl(url: url)
                result(true)
              } else {
                result(FlutterError.init(code: "errorSetDebug", message: "funcSetLocationPostUrl: data or format error", details: nil))
              }
          result(true)
				case AppDelegate.funcGetNewAccessToken:
					result(AppDelegate.newToken)
					break;
				case AppDelegate.funcDeleteNewAccessToken:
					AppDelegate.newToken = nil
					result(nil)
        default:
          result(FlutterMethodNotImplemented)
          return
        }
    })
    
    appEventChannel.setStreamHandler(self)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  public func onListen(withArguments arguments: Any?,
                           eventSink: @escaping FlutterEventSink) -> FlutterError? {
    LocationManager.shared.setEventSink(eventSink: eventSink)
    let funcResult = startService()
    print("onListen: called: \(funcResult)")
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    LocationManager.shared.setEventSink(eventSink: nil)
    print("onCalcel: called")
    return nil
  }

  func startService() -> Bool {
    if (!LocationManager.shared.isHasAccess()) {
      LocationManager.shared.requestAccess()
      return false
    }
    LocationManager.shared.startMonitoring()
    return true
  }

  func stopService() -> Bool {
    if (LocationManager.shared.state == LocationManager.State.Monitoring) {
      LocationManager.shared.stopMonitoring()
    }
    return true
  }

  func startTracking() -> Bool {
    LocationManager.shared.isTracking = true
		tokenEventChannel?.setStreamHandler(LocationManager.shared)
    return true
  }

  func stopTracking() -> Bool {
    LocationManager.shared.isTracking = false
		tokenEventChannel?.setStreamHandler(nil)
    return true
  }

  func isServiceStarted() -> Bool {
    return LocationManager.shared.state == LocationManager.State.Monitoring
  }

  func isTracking() -> Bool {
    return LocationManager.shared.isTracking
  }

  func getPathNodes() -> Array<Dictionary<String, Any?>> {
    return (AppDelegate.pathNodes.map() { e in
      e.toMap()
    })
  }

  func clearPathNodes() -> Bool {
    AppDelegate.pathNodes.removeAll(keepingCapacity: false)
    return true
  }
    
  func setToken(token: String) {
    AppDelegate.token = token
  }
    
  func setJobId(jobId: Int) {
    AppDelegate.jobId = jobId
  }
	
	func setLocationPostUrl(url: String) {
		AppDelegate.locationPostUrl = url
	}
}

// MARK: Declarations
class LocationManager: NSObject, FlutterStreamHandler {
	func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
		_tokenEventSink = events
		return nil
	}
	
	func onCancel(withArguments arguments: Any?) -> FlutterError? {
		_tokenEventSink = nil
		return nil
	}
	
  /// Alias to CLAuthorizationStatus, makes accessable throughout the project
  /// without importing the CoreLocation kit.
  typealias LocationAuthStatus = CLAuthorizationStatus
  enum State {
      case Idle, Monitoring
  }
  
  /// Singleton Object
  static let shared = LocationManager()
  
  private var _eventSink: FlutterEventSink?
	private var _tokenEventSink: FlutterEventSink?
  public var isTracking = false
  private var _lastSpeed = 0.0
	private var _lastTimeInSec = 0
  
  public func setEventSink(eventSink: FlutterEventSink?) {
    _eventSink = eventSink
  }
  
  private var _state: State = .Idle {
      didSet {
  
      }
  }
  public var state: State {
      get { return _state }
  }
  private var manager: CLLocationManager!
  
  private override init() {
      super.init()
      self.setup()
  }
  
  // cleanup
  deinit {
      self.teardown()
      print("Location Manager Killed")
  }
}

private extension LocationManager {
    func setup() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager?.delegate = self
        manager?.allowsBackgroundLocationUpdates = true
        manager?.pausesLocationUpdatesAutomatically = false
        manager?.distanceFilter = kCLDistanceFilterNone
    }
    
    func teardown() {
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func _postAction(jobId: Int?, addedTime: Int?, latitude: Double?, longitude: Double?) {
				if (AppDelegate.locationPostUrl == nil) {
					print("location url is null")
					return
				}
        let Url = String(format: AppDelegate.locationPostUrl!)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = [
            "jobId": jobId ?? -1,
            "addedTime": addedTime ?? -1,
            "latitude": "\(latitude ?? 0)",
            "longitude": "\(longitude ?? 0)"
        ] as [String : Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AppDelegate.token ?? "")", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary,   options: []) else {
            return
        }
        request.httpBody = httpBody
    
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
							do {
								if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
									if let newAccessToken = json["newAccessToken"] as? String {
										AppDelegate.newToken = newAccessToken
										AppDelegate.token = newAccessToken
										self._tokenEventSink?(newAccessToken)
									}
									print(json)
								}
							} catch {
								print(error)
							}
            }
        }.resume()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization" , manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
      print("didUpdateLocation: ", locations)
      
			let timestampInSec = Int(locations.last?.timestamp.timeIntervalSince1970 ?? 0)
			
      let isAddedToPathNodes = (
        (locations.last?.speed ?? 0.0 > 0.1
          || self._lastSpeed != 0.0)
          || AppDelegate.pathNodes.isEmpty) && self.isTracking
                    
      let data : LocationData = LocationData(
        latitude: locations.last?.coordinate.latitude ?? nil,
        longitude: locations.last?.coordinate.longitude ?? nil,
        altitude: locations.last?.altitude ?? nil,
        speed: locations.last?.speed ?? nil,
        bearing: locations.last?.course ?? nil,
        accuracy: (locations.last?.horizontalAccuracy ?? 0.0 +
                  (locations.last?.verticalAccuracy ?? 0.0)) / 2,
        timeAtMillis: timestampInSec * 1000,
        isAddToPathNodes: isAddedToPathNodes
      )
      _eventSink?(data.toMap())
			
	//   uncommend for apply 5 seconds post interval.
	//			if (timestampInSec - _lastTimeInSec < 5) {
	//				return
	//			}
				
      if (isAddedToPathNodes) {
        AppDelegate.pathNodes.append(data)
      
        _postAction(jobId: AppDelegate.jobId, addedTime: timestampInSec, latitude: data.latitude, longitude: data.longitude)
      }
			
			_lastSpeed = data.speed ?? 0.0
			_lastTimeInSec = timestampInSec
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case CLError.Code.denied:
                
                fallthrough
            default:
                print("locationManager: didFailWithError", clError)
            }
            // reset state
            self._state = .Idle
        }
    }
}

extension LocationManager {
    
    func isHasAccess() -> Bool {
        var isHas = true
        if let authStatus = self.manager?.authorizationStatus {
            if authStatus == .notDetermined || authStatus == .denied || authStatus == .restricted {
                isHas = false
            }
            return isHas
        }
        return false
    }
    
    func requestAccess() {
        manager?.requestAlwaysAuthorization()
    }

}

extension LocationManager {
  func startMonitoring() {
    guard self.isHasAccess() else {
      print("WARN: App Doesnt have access to CoreLocation, please call LocationManager.shared.isHasAccess() first")
      return
    }
    guard self.state == .Idle else {
      print("WARN: LocationManager already running")
      return
    }
    
    // sned to global queue
    DispatchQueue.global().async {
      // Guard has location services
      guard CLLocationManager.locationServicesEnabled() else {
          return
      }
      self._state = .Monitoring
      self.manager?.startUpdatingLocation()
      /// Optional:
      /// Only work if app has .authorizedAlways access,
      /// shows the blue indicator in the status bar,
      /// if app has .authorizedWhenInUse, the blue indicator on by default
      /// so we manually turn it on in any case to inform
      /// the user that we are working in the background
      self.manager.showsBackgroundLocationIndicator = true
    }
  }
  
  func stopMonitoring() {
    guard self.state != .Idle else {
      print("WARN: LocationManager already stopped")
      return
    }
    
    _eventSink = nil
    
    self.manager?.stopUpdatingLocation()
    self._state = .Idle
    /// turn off blue indicator
    self.manager.showsBackgroundLocationIndicator = false
  }
}

// model class for keeping location data, and allows converting to map
class LocationData {
  var latitude: Double?
  var longitude: Double?
  var altitude: Double?
  var speed: Double?
  var bearing: Double?
  var accuracy: Double?
  var timeAtMillis: Int?
  var isAddToPathNodes: Bool?
  
  init(latitude: Double?, longitude: Double?, altitude: Double?, speed: Double?, bearing: Double?, accuracy: Double?, timeAtMillis: Int?, isAddToPathNodes: Bool?) {
    self.latitude = latitude
    self.longitude = longitude
    self.altitude = altitude
    self.speed = speed
    self.bearing = bearing
    self.accuracy = accuracy
    self.timeAtMillis = timeAtMillis
    self.isAddToPathNodes = isAddToPathNodes
  }
  
  static func fromMap(rawData: Dictionary<String, Any?>) -> LocationData {
    let latitude = rawData["latitute"] as? Double
    let longitude = rawData["longitute"] as? Double
    let altitude = rawData["altitude"] as? Double
    let speed = rawData["speed"] as? Double
    let bearing = rawData["bearing"] as? Double
    let accuracy = rawData["accuracy"] as? Double
    let timeAtMillis = rawData["timeAtMillis"] as? Int
    let isAddToPathNodes = rawData["isAddToPathNodes"] as? Bool
    
    return LocationData(
      latitude: longitude,
      longitude: latitude,
      altitude: altitude,
      speed: speed,
      bearing: bearing,
      accuracy: accuracy,
      timeAtMillis: timeAtMillis,
      isAddToPathNodes: isAddToPathNodes
    )
  }
  
  func toMap() -> Dictionary<String, Any?> {
    return [
      "latitude": self.latitude,
      "longitude": self.longitude,
      "altitude": self.altitude,
      "speed": self.speed,
      "bearing": self.bearing,
      "accuracy": self.accuracy,
      "timeAtMillis": self.timeAtMillis,
      "isAddToPathNodes": self.isAddToPathNodes
    ]
  }
}
