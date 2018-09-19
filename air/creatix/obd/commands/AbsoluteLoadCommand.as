package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
public class AbsoluteLoadCommand extends ObdCommand {
    private var percentage:int = -1;
	public const PID="0143";
	public const name="AbsoluteLoadCommand";
    public function AbsoluteLoadCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        //100.0f * buffer.get(2) / 255.0f;
		var rbytes=air.creatix.obd.Util.toArray(response);
		//trace("bytes:"+rbytes[2]+" "+rbytes[3]); (a * 256 + b) * 100 / 255;
		percentage= (rbytes[2]*256+rbytes[3]) / 255.0;
		
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
