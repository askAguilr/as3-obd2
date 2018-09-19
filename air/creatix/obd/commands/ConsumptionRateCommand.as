package  air.creatix.obd.commands{
import air.creatix.obd.Util;
	
	//Consumo instantáneo de gasolina en litros por hora
public class ConsumptionRateCommand extends ObdCommand {
    private var value:Number = 0;
	public const PID="015E";
	public const name="ConsumptionRateCommand";
    public function ConsumptionRateCommand() {
        super(PID);
    }

	//calculate values
    override public function performCalculations():Object {
        // ignore first two bytes [41 0C] of the response((A*256)+B)/4
        //rpm = (buffer.get(2) * 256 + buffer.get(3)) / 4; (buffer.get(2) * 256 + buffer.get(3)) * 0.05f;
		var rbytes=air.creatix.obd.Util.toArray(response);
		value=(rbytes[2]*256+rbytes[3])*0.05;
		var data:Object=new Object();
		data.value=value
		return data;
    }
	//returns result as they are
	public function getResult(){
		return value;
	}



}

	
}
