package air.creatix.obd {
	import air.creatix.obd.sockets.*;
	import air.creatix.obd.commands.*;
	import air.creatix.obd.*;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class ObdDevice extends EventDispatcher {
		public var stepDelay = 5; //allow 5ms between every command at least
		public var timeoutDelay = 30000;
		public var protocolDelay = 3000;
		public var timeout_timer: Timer;
		public var initializationCommand = "ATE0|ATZ|ATE0|ATM0|ATL1|ATST62|ATS0|AT@1|ATI|ATH0|ATAT2|ATSP0";
		private var reconnect_timer: Timer;
		private var buffer = "";
		private var expecting_prompt = false;
		private var queue: Array;
		private var com: ComSocket;
		private var current_command: int = 0;
		private var cmd: ObdCommand;
		private var commands: Array;
		private var step_timer = new Timer(stepDelay, 1);

		public function ObdDevice(p: ComSocket) {
			reconnect_timer = new Timer(3000);
			reconnect_timer.addEventListener(TimerEvent.TIMER, reconnect);
			timeout_timer = new Timer(timeoutDelay, 1);
			timeout_timer.addEventListener(TimerEvent.TIMER, timedOut);
			step_timer.addEventListener(TimerEvent.TIMER, stepTimed);
			commands = new Array();
			queue = new Array();
			com = p;
			com.addEventListener(ComSocketEvent.DISCONNECTED, function (e: ComSocketEvent) {
				reconnect_timer.reset();
				reconnect_timer.start();
				step_timer.stop();
				timeout_timer.stop();
			});
			com.addEventListener(ComSocketEvent.DATA_RECEIVED, responseReceived);
			com.addEventListener(ComSocketEvent.CONNECTED, function (e: ComSocketEvent) {
				reconnect_timer.stop();
				trace("Connected");
				initialize();
			});
			com.connect();

		}

		public function initialize() {
			run(new PidDetectionCommand(), true);
			var cmds: Array = initializationCommand.split("|");
			cmds.reverse();
			for each(var icmd: String in cmds) {
				run(new GenericCommand(icmd), true);
			}
			step_timer.reset();
			step_timer.start();
			timeout_timer.delay = timeoutDelay;
			timeout_timer.reset();
			timeout_timer.start();
		}

		public function reconnect(e = null) {
			com.connect();
		}

		//triggered when a response from the obd device is received
		private function responseReceived(e: ComSocketEvent) {
			buffer += e.params.string;
			trace("responseReceived - buffer:"+buffer);
			var j = 0;
			var command = "";
			if (buffer.indexOf(">") >= 0) {
				trace("Mayor que o no expecting");
				step_timer.reset();
				step_timer.start();
				timeout_timer.stop();
			}
			while (buffer.indexOf("\r") >= 0) {
				j = buffer.indexOf("\r");
				command = buffer.substring(0, j);
				Util.print(" <<<<<<<<<---------- " + command);
				command = air.creatix.obd.Util.removeRareChars(command);
				buffer = buffer.substr(buffer.indexOf("\r") + 1);
				buffer = buffer.substr(buffer.indexOf(">") + 1);
				detectarEvento(command);
				
			}
		}

		private function detectarEvento(command: String) {
			if (command.substr(0, 2) == "OK") { //OK is not a command result but an AT result
				return;
			}
			if (command.substr(0, 17) == "NO DATA CAN ERROR") { //Error in communication, restart protocol
				initialize();
				return;
			}
			if (command.substr(0, 17) == "BUS INIT... ERROR") { //NO DATA
				initialize();
				return;
			}
			if (command.substr(0, 17) == "UNABLE TO CONNECT") { //NO DATA
				//initialize();
				return;
			}
			if (command.substr(0, 9) == "NO DATA") {
				return;
			}
			if (command.substr(0, 9) == "SEARCHING") {
				return;
			}
			if (command.substr(0, 1) == "?") {
				return;
			}
			if (command.substr(0, 7) == "STOPPED") {
				return;
			}
			if (command.substr(0, 5) == "ERROR") {
				return;
			}
			if (command.substr(0, 4) == "410C") { //RPM result
				Util.print("Dispatch RPM response");
				var tcmd = new RPMCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.RPM, data));
				return;
			}
			if (command.substr(0, 4) == "412F") {
				Util.print("Dispatch Fuel response");
				var tcmd = new FuelCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.FuelPercentage, data));
				return;
			}
			if (command.substr(0, 4) == "4143") {
				Util.print("Dispatch AbsoluteLoadCommand");
				var tcmd = new AbsoluteLoadCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.AbsoluteLoad, data));
				return;
			}
			if (command.substr(0, 4) == "4111") {
				Util.print("Dispatch ThrottlePositionCommand");
				var tcmd = new ThrottlePositionCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.ThrottlePosition, data));
				return;
			}
			if (command.substr(0, 4) == "411F") {
				Util.print("Dispatch RuntimeCommand");
				var tcmd = new RuntimeCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.Runtime, data));
				return;
			}
			if (command.substr(0, 4) == "415E") {
				Util.print("Dispatch ConsumptionRateCommand");
				var tcmd = new ConsumptionRateCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.ConsumptionRate, data));
				return;
			}
			if (command.substr(0, 4) == "4121") {
				var tcmd = new DistanceOnMilCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.DistanceOnMil, data));
				return;
			}
			if (command.substr(0, 4) == "4131") {
				var tcmd = new DistanceSinceCCCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.DistanceSinceCC, data));
				return;
			}
			if (command.substr(0, 4) == "4101") {
				var tcmd = new DtcNumberCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.DtcNumber, data));
				return;
			}
			if (command.substr(0, 4) == "4142") {
				var tcmd = new ModuleVoltageCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.ModuleVoltage, data));
				return;
			}
			if (command.substr(0, 2) == "47") {
				var tcmd = new PendingTroubleCodesCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.PendingTroubleCodes, data));
				return;
			}
			if (command.substr(0, 2) == "4A") {
				var tcmd = new PermanentTroubleCodesCommand();
				tcmd.receiveCommand(command);
				var data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.PermanentTroubleCodes, data));
				return;
			}
			if (command.substr(0, 2) == "43") {
				var tcmd = new TroubleCodesCommand();
				tcmd.receiveCommand(command);
				var data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.TroubleCodes, data));
				return;
			}
			if (command.substr(0, 2) == "44") {
				var tcmd = new ClearCodesCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.ClearCodes, data));
				return;
			}
			if (command.substr(0, 4) == "4902") {
				var tcmd = new VinCommand();
				tcmd.receiveCommand(command);
				var data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.Vin, data));
				return;
			}
			if (command.substr(0, 4) == "410D") {
				var tcmd = new SpeedCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.Speed, data));
				return;
			}
			if (command.substr(0, 4) == "410F") {
				var tcmd = new AirIntakeTemperatureCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.AirIntakeTemperature, data));
				return;
			}
			if (command.substr(0, 4) == "4146") {
				var tcmd = new AmbientAirTemperatureCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.AmbientAirTemperature, data));
				return;
			}
			if (command.substr(0, 4) == "4105") {
				var tcmd = new EngineCoolantTemperatureCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.EngineCoolantTemperature, data));
				return;
			}
			if (command.substr(0, 4) == "415C") {
				var tcmd = new OilTempCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data.value = tcmd.performCalculations().value;
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.OilTemp, data));
				return;
			}
			if (command.substr(0, 4) == "4100") {
				var tcmd = new PidDetectionCommand();
				tcmd.receiveCommand(command);
				var data = new Object();
				data = tcmd.performCalculations();
				data.response = tcmd.response;
				dispatchEvent(new ObdEvent(ObdEvent.PidDetection, data));
				return;
			}
			//cuando no fue ninguno de los anteriores es genérico
			var tcmd = new GenericCommand();
			tcmd.receiveCommand(command);
			var data = new Object();
			data.response = tcmd.response;
			dispatchEvent(new ObdEvent(ObdEvent.Generic, data));
			return;
		}

		//triggered when no response was received from the obd and timed out the request
		private function timedOut(e) {
			Util.print("timed out");

			nextCommand();
		}

		//triggered when the command delay is finished and another command can be run;
		private function stepTimed(e) {
			Util.print("step");
			nextCommand();
		}

		//queues an obd command to be run ASAP
		public function run(cmd: ObdCommand, urgent = false) {
			if (urgent) {
				queue.unshift(cmd);
			} else {
				queue.push(cmd);
			}
		}

		//makes an obd command recurring, the more you add slower response you get
		public function subscribe(command: ObdCommand) {
			//TODO: verify it's not already suscribed
			commands.push(command);
		}

		//runs the next queued command (round robin)
		private function nextCommand() {
			Util.print("nextcommand");
			timeout_timer.reset();
			timeout_timer.delay = timeoutDelay;
			timeout_timer.start();
			step_timer.stop();
			//trace("current_command:"+current_command+" lenght:"+commands.length);
			if (current_command >= commands.length) {
				current_command = 0;
			}

			if (queue.length > 0) {
				cmd = queue.shift();
				step_timer.delay = stepDelay;
				expecting_prompt = true;
				if (cmd.cmd.indexOf("AT") >= 0) { //delay esperado en AT es de 500ms
					step_timer.delay = 500;
					expecting_prompt = false;
				}
				if (cmd.cmd.indexOf("ATSP") >= 0) { //delay esperado en AT es de 5000ms
					step_timer.delay = protocolDelay;
				}
				cmd.sendCommand(com);
			} else if (commands.length > 0) {
				cmd = commands[current_command];
				cmd.sendCommand(com);
			}
			current_command++;
		}
	}

}