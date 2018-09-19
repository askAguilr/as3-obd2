package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	
	//cantidad de errores activos
public class ClearCodesCommand extends ObdCommand {
	public const PID="04";
	public const name="ClearCodesCommand";
	public var value:int=0;
	
    public function ClearCodesCommand() {
        super(PID);
    }

	
	//calculate values
    override public function performCalculations():Object {
		var data:Object=new Object();
		data.value=1;
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}

}

	
}
