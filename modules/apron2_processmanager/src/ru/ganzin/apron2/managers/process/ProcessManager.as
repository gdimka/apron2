package ru.ganzin.apron2.managers.process
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.SimpleClass;
	import ru.ganzin.apron2.apron_internal;

	public class ProcessManager extends SimpleClass
	{
		use namespace apron_internal;
		
		private var target:IEventDispatcher;
		private var processesMap:Dictionary = new Dictionary(false);
		private var addingProcessesMap:Dictionary = new Dictionary(false);
		private var removingProcessesMap:Dictionary = new Dictionary(false);

		private var waiting:Boolean = false;
		private var nextFreeId:int = 0;
		
		/*******************************************************************************************************/
		public function ProcessManager(target:IEventDispatcher = null)
		{
			if (!target) target = new Sprite();
			this.target = target;
		}
		/*******************************************************************************************************/
		private function run(event:Event):void
		{
			waiting = true;
			
			var processesList:Vector.<Process> = processesMap[event.type];
			var removingProcessesList:Vector.<Process> = removingProcessesMap[event.type];
			var addingProcessesList:Vector.<Process> = addingProcessesMap[event.type];
			
			if (processesList)
			{
				for (var i:int=0;i<processesList.length;i++)
				{
					var process:Process = processesList[i];				
					if (removingProcessesList && removingProcessesList.indexOf(process) != -1) continue;

					var ret:int = process.run();
					if (ret == ProcessState.COMPLETED)
					{
						processesList.splice(i--,1);
						
						if (hasEventListener(ProcessManagerEvent.PROCESS_COMPLETED))
							dispatchEvent(new ProcessManagerEvent(ProcessManagerEvent.PROCESS_COMPLETED, process));

						if (process.hasEventListener(ProcessEvent.REMOVED))
							process.dispatchEvent(new ProcessManagerEvent(ProcessEvent.REMOVED, process));
					}
					else if (ret == ProcessState.HOLD )
					{
						if (hasEventListener(ProcessManagerEvent.PROCESS_HOLDED))
							dispatchEvent(new ProcessManagerEvent(ProcessManagerEvent.PROCESS_HOLDED, process));

						return;
					}
				}
			}
			
			waiting = false;
			
			updateProcessList();
		}
		/*******************************************************************************************************/
		private function updateProcessList():void
		{
			if (waiting) return;
			
			var eventName:String;
			var list:Vector.<Process>;
			var processesList:Vector.<Process>;
			var sList:Vector.<Process>;
			
			for (eventName in removingProcessesMap)
			{
				list = removingProcessesMap[eventName];
				processesList = processesMap[eventName];
				
				if (!processesList || !list || list.length == 0) continue;
				
				while(list.length > 0)
				{
					var remId:int = processesList.indexOf(list.shift());
					if (remId != -1)
					{
						sList = processesList.splice(remId,1);
						if (sList[0] != null)
						{
							if (sList[0].hasEventListener(ProcessEvent.REMOVED))
								sList[0].dispatchEvent(new ProcessManagerEvent(ProcessEvent.REMOVED, process));
						}
					}
				}
				
				if (processesList.length == 0)
				{
					delete processesMap[eventName];
					target.removeEventListener(eventName,run);
				}
			}

			for (eventName in addingProcessesMap)
			{
				list = addingProcessesMap[eventName];
				processesList = processesMap[eventName];
				
				if (!list || list.length == 0) continue;
				if (!processesList)
				{
					processesMap[eventName] = processesList = new Vector.<Process>();
				}
				if (!target.hasEventListener(eventName)) target.addEventListener(eventName,run,false,0,true);
					
				while (list.length > 0)
				{
					var process:Process = list.shift();
					if (process.priority > -1) processesList.splice(process.priority,0,process);
					else processesList.push(process);

					if (process.hasEventListener(ProcessEvent.ADDED))
						process.dispatchEvent(new ProcessManagerEvent(ProcessEvent.ADDED, process));
				}
			}
		}
		/*******************************************************************************************************/
		public function addProcess(process:Process):int
		{
			process.id = nextFreeId++;
			
			var addingProcessesList:Vector.<Process> = addingProcessesMap[process.eventName];
			if (!addingProcessesList) addingProcessesMap[process.eventName] = addingProcessesList = new Vector.<Process>();
			addingProcessesList.push(process);
			
			updateProcessList();
			
			return process.id;
		}
		/*******************************************************************************************************/
		public function getProcess(id:int):Process
		{
			return findProcessById(id);
		}
		
		private function findProcessById(id:int, info:Object = null):Process
		{
			var processesList:Vector.<Process>;
			var process:Process;
			
			for each (processesList in processesMap)
				for each(process in processesList)
					if (process.id == id)
					{
						if (info) info["inProcessMap"] = true;
						return process;
					}
			
			for each (processesList in addingProcessesMap)
				for each(process in processesList)
					if (process.id == id)
					{
						if (info) info["inAddingProcessMap"] = true;
						return process;
					}
			
			return null;			
		}

		private function findProcessByProcess(value:Process, info:Object = null):Process
		{
			var processesList:Vector.<Process>;
			var process:Process;

			for each (processesList in processesMap)
				for each(process in processesList)
					if (process.equals(value))
					{
						if (info) info["inProcessMap"] = true;
						return process;
					}

			for each (processesList in addingProcessesMap)
				for each(process in processesList)
					if (process.equals(value))
					{
						if (info) info["inAddingProcessMap"] = true;
						return process;
					}

			return null;
		}

		/*******************************************************************************************************/
		public function removeAllProcesses():void
		{
			processesMap = new Dictionary();
			addingProcessesMap = new Dictionary();
			removingProcessesMap = new Dictionary();
		}
		/*******************************************************************************************************/
		public function removeProcess(value:*):Boolean
		{
			var info:Object = {};
			var process:Process;

			if (value is int) process = findProcessById(value, info);
			else if (value is Process) process = findProcessByProcess(value, info);

			if (process)
			{
				if (info["inAddingProcessMap"])
				{
					var addingProcessesList:Vector.<Process> = addingProcessesMap[process.eventName];
					if (addingProcessesList)
					{
						var index:int = addingProcessesList.indexOf(process);
						if (index != -1) addingProcessesList.splice(index,1);
					}
				}
				else
				{
					var removingProcessesList:Vector.<Process> = removingProcessesMap[process.eventName];
					if (!removingProcessesList) removingProcessesMap[process.eventName] = removingProcessesList = new Vector.<Process>();
					if (removingProcessesList.indexOf(process) == -1) removingProcessesList.push(process);
				}

				updateProcessList();

				return true;
			}
			return false;
		}
		/*******************************************************************************************************/
		public function removeProcessById(id:int):Boolean
		{
			return removeProcess(id);
		}
		/*******************************************************************************************************/
		public function removeProcessByProcess(process:Process):Boolean
		{
			return removeProcessById(process.id);
		}
		/*******************************************************************************************************/
		public function hasProcess(process:Process):Boolean
		{
			var findProcess:Process = getProcess(process.id);
			return findProcess && findProcess.equals(process);
		}
		/*******************************************************************************************************/
	}
}
