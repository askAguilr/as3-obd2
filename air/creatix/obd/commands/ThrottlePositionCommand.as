package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
public class ThrottlePositionCommand extends ObdCommand {
    private var percentage:int = -1;
	public const PID="0111";
	public const name="ThrottlePositionCommand";
    public function ThrottlePositionCommand() {
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
