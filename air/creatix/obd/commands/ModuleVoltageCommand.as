package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//cantidad de errores activos
public class ModuleVoltageCommand extends ObdCommand {
    private var value:int = -1;
	public const PID="0142";
	public const name="modulevoltage";
    public function ModuleVoltageCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        //100.0f * buffer.get(2) / 255.0f;
		var rbytes=air.creatix.obd.Util.toArray(response);
		//trace("bytes:"+rbytes[2]+" "+rbytes[3]);
		value=(rbytes[2] * 256 + rbytes[3]) / 1000;
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
