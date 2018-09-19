package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
public class FuelCommand extends ObdCommand {
    private var percentage:int = -1;
	public const PID="012F";
	public const name="fuel";
    public function FuelCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        //100.0f * buffer.get(2) / 255.0f;
		var rbytes=air.creatix.obd.Util.toArray(response);
		//trace("bytes:"+rbytes[2]+" "+rbytes[3]);
		percentage=100.0 * rbytes[2] / 255.0;
		var data:Object=new Object();
		data.value=Number(percentage);
		return data;
    }
	//returns result as they are
	public function getResult(){
		return percentage;
	}

}

	
}
