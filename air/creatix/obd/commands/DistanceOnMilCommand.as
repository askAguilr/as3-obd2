package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//Km con la luz de check engine encendido
public class DistanceOnMilCommand extends ObdCommand {
    private var value:int = -1;
	public const PID="0121";
	public const name="distanceonmil";
    public function DistanceOnMilCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        //100.0f * buffer.get(2) / 255.0f;
		var rbytes=air.creatix.obd.Util.toArray(response);
		//trace("bytes:"+rbytes[2]+" "+rbytes[3]);
		value=rbytes[2] * 256 + rbytes[3];
		var data:Object=new Object();
		data.value=Number(value);
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}

}

	
}
