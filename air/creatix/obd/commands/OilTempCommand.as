﻿package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//cantidad de errores activos
public class OilTempCommand  extends ObdCommand {
    private var value:int = -1;
	public const PID="015C";
	public const name="OilTempCommand";
    public function OilTempCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
		var rbytes=air.creatix.obd.Util.toArray(response);
		//trace("bytes:"+rbytes[2]+" "+rbytes[3]);
		//value=(rbytes[2] * 256 + rbytes[3]) / 1000;
		var data:Object=new Object();
		data.value=Number(rbytes[2]-40);
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}

}

	
}

