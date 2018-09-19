package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//Km desde que se encendió el motor
public class RuntimeCommand extends ObdCommand {
    private var value = -1;
	public const PID="011F";
	public const name="RuntimeCommand";
    public function RuntimeCommand() {
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
