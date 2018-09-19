package air.creatix.obd{
 import flash.events.*;
  
 public class ObdEvent extends Event {
	  public var data:Object;
	  public static const RPM:String = "rpm";
	  public static const Speed:String = "speed";
	  public static const FuelPercentage:String = "fuel";
	  public static const AbsoluteLoad:String = "AbsoluteLoadCommand";
	  public static const ThrottlePosition:String = "ThrottlePositionCommand";
	  public static const Runtime:String = "RuntimeCommand";
	  public static const ConsumptionRate:String = "ConsumptionRateCommand";
	  public static const DistanceOnMil:String = "distanceonmil";
	  public static const DistanceSinceCC:String = "distancesincecc";
	  public static const DtcNumber:String = "dtcnumber";
	  public static const ClearCodes:String = "ClearCodesCommand";
	  public static const ModuleVoltage:String = "modulevoltage";
	  public static const EngineCoolantTemperature:String = "EngineCoolantTemperatureCommand";
	  public static const AirIntakeTemperature:String = "AirIntakeTemperatureCommand";
	  public static const AmbientAirTemperature:String = "AmbientAir";
	  public static const OilTemp:String = "OilTempCommand";
	  public static const PendingTroubleCodes:String = "pendingtroublecodes";
	  public static const PermanentTroubleCodes:String = "permanenttroublecodes";
	  public static const TroubleCodes:String = "troublecodes";
	  public static const Vin:String = "vin";
	  public static const PidDetection:String = "piddetection";
	  public static const Generic:String = "generic";
	 
		 public function ObdEvent($type:String, $params:Object=null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			this.data = $params;
		}

	  public override function clone():Event {
	    return new ObdEvent(type, this.data, bubbles, cancelable);
	  }
 }
}
