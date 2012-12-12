/**
 * Copyright (C) 2008 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package ru.ganzin.apron2.mvn.puremvc.fabrication.fabricator
{
	import flash.events.Event;

	import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ApplicationStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ModuleStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;

	import ru.ganzin.apron2.mvn.puremvc.fabrication.SimpleApplication;

	/**
	 * FlashApplicationFabricator is the concrete fabricator for Flash applications.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class SimpleApplicationFabricator extends ApplicationFabricator
	{
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabrication
		 */
		public function SimpleApplicationFabricator(fabrication:SimpleApplication)
		{
			super(fabrication);
		}
		
		private function get application():SimpleApplication
		{
			return fabrication as SimpleApplication;
		}
		
		/**
		 * Provides the readyEventName for FlexApplications, i.e:- creationComplete. 
		 */		
		override protected function get readyEventName():String
		{
			return Event.INIT;
		}
		
		/**
		 * Registers the ApplicationStartupCommand to configure fabrication for
		 * a flex application environment. If a router is not present this is
		 * a shell application else it is a module application.
		 */
		override protected function initializeEnvironment():void
		{
			if (router == null)
			{
				facade.registerCommand(FabricationNotification.STARTUP, ApplicationStartupCommand);
			}
			else
			{
				facade.registerCommand(FabricationNotification.STARTUP, ModuleStartupCommand);
			}
		}
		
		override protected function startApplication():void
		{
//			var appRunCommand:Class = application.getApplicationRunCommmand();
			facade.registerCommand(FabricationNotification.BOOTSTRAP, application.getModulesStartupCommand());
//			if (appRunCommand) facade.registerCommand(FabricationNotification.BOOTSTRAP, appRunCommand);
			super.startApplication();
		}
		
	}
}