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
 
package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator {
	import mx.events.FlexEvent;

	import org.puremvc.as3.multicore.utilities.fabrication.components.FlexApplication;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ApplicationStartupCommand;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;

	/**
	 * FlexApplicationFabricator is the concrete fabricator for Flex applications.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FlexApplicationFabricator extends ApplicationFabricator {
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabrication
		 */
		public function FlexApplicationFabricator(_fabrication:FlexApplication) {
			super(_fabrication);
		}

		/**
		 * Provides the readyEventName for FlexApplications, i.e:- creationComplete. 
		 */		
		override protected function get readyEventName():String {
			return FlexEvent.CREATION_COMPLETE;
		}
		
		/**
		 * Registers the ApplicationStartupCommand to configure fabrication for
		 * a flex application environment.
		 */
		override protected function initializeEnvironment():void {
			facade.registerCommand(FabricationNotification.STARTUP, ApplicationStartupCommand);
		}
		
	}
}
