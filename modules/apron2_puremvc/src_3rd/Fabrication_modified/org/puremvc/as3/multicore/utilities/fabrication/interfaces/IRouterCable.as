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
 
package org.puremvc.as3.multicore.utilities.fabrication.interfaces {

	/**
	 * An interface to describe the input and output pipe fittings of an
	 * application module.
	 * 
	 * @author Darshan Sawardekar
	 */
	public interface IRouterCable extends IDisposable {

		/**
		 * Returns the input message pipe fitting of the current 
		 * application module.
		 */
		function getInput():INamedPipeFitting;

		/**
		 * Returns the output message pipe fitting of the current 
		 * application module.
		 */
		function getOutput():INamedPipeFitting;
	}
}
