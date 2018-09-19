package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
public class RPMCommand extends ObdCommand {
    private var rpm:int = -1;
	public const PID="010C";
	public const name="rpm";
    public function RPMCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        // ignore first two bytes [41 0C] of the response((A*256)+B)/4
        //rpm = (buffer.get(2) * 256 + buffer.get(3)) / 4;
		var rbytes=air.creatix.obd.Util.toArray(response);
		trace("bytes:"+rbytes[2]+" "+rbytes[3]);
		rpm=(rbytes[2]*256+rbytes[3])/4;
		var data:Object=new Object();
		data.value=Number(rpm);
		return data;
    }
	//returns result as they are
	public function getResult(){
		return rpm;
	}

    public function getRPM():int {
        return rpm;
    }

}

	
}
