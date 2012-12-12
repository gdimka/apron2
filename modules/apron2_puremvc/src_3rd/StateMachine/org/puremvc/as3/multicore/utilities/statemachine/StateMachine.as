/*
  PureMVC AS3 Utility - StateMachine
  Copyright (c) 2008 Neil Manuell, Cliff Hall
  Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.statemachine
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * A Finite State Machine implimentation.
	 * <P>
	 * Handles regisistration and removal of state definitions, 
	 * which include optional entry and exit commands for each 
	 * state.</P>
	 */
	public class StateMachine extends Mediator
	{
		public static const NAME:String = "StateMachine"

		/**
		 * Action Notification name. 
		 */ 
		public static const ACTION:String = NAME+"/notes/action" ;

		/**
		 *  Changed Notification name  
		 */ 
		public static const CHANGED:String = NAME + "/notes/changed";
		
		/**
		 *  Cancel Notification name  
		 */ 
		public static const CANCEL:String = NAME+"/notes/cancel";
		
		/**
		 * Constructor.
		 */
		public function StateMachine( )
		{
			super( NAME );
		}
		
		override public function onRegister():void
		{
			if ( initial ) transitionTo( initial );	
		}
		
		/**
		 * Registers the entry and exit commands for a given state.
		 * 
		 * @param state the state to which to register the above commands
		 * @param initial boolean telling if this is the initial state of the system
		 */
		public function registerState( state:State, initial:Boolean=false ):void
		{
			if ( state == null || states[ state.name ] != null ) return;
			states[ state.name ] = state;
			if ( initial ) this.initial = state; 
		}
		
		/**
		 * Remove a state mapping. 
		 * <P>
		 * Removes the entry and exit commands for a given state 
		 * as well as the state mapping itself.</P>
		 * 
		 * @param state
		 */
		public function removeState( stateName:String ):void
		{
			var state:State = states[ stateName ];
			if ( state == null ) return;
			states[ stateName ] = null;
		}
		
		/**
		 * Transitions to the given state from the current state.
		 * <P>
		 * Sends the exiting notification for the current state 
		 * and the entering notification for the new state.</P>
		 * <P>
		 * Both the exiting notification for the current state
		 * and the entering notification for the next state
		 * will have a reference to the next state in the note
		 * body.</P>
		 * 
		 * @param nextState the next State to transition to.
		 */
		protected function transitionTo( nextState:State ):void
		{
			// Going nowhere?
			if ( nextState == null ) return;
			
			// Clear the cancel flag
			canceled = false;
				
			// Exit the current State (if set)
			if( currentState ) {
				if ( nextState.name == currentState.name ) return;
				if ( currentState.exiting ) sendNotification( currentState.exiting, nextState );
			}
			
			// Check to see whether the transition has been canceled
			if ( canceled ) {
				canceled = false;
				return;
			}
			
			// Enter the next State 
			if ( nextState.entering ) sendNotification( nextState.entering, nextState );
			currentState = nextState;
			
			// Notify the app that the state changed and what the new state is 
			sendNotification( CHANGED, currentState );
		}
		
		/**
		 * Notification interests for the StateMachine.
		 */
		override public function listNotificationInterests():Array
		{
			return [ 	ACTION,
						CANCEL	];
		}
		
		/**
		 * Handle notifications the <code>StateMachine</code> is interested in.
		 * <P>
		 * <code>StateMachine.ACTION</code>: Triggers the transition to a new state.<BR>
		 * <code>StateMachine.CANCEL</code>: Cancels the transition if sent in response to the exiting note for the current state.<BR>
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				case ACTION:
					var action:String = note.getType();
					var target:String = currentState.getTarget( action );
					var newState:State = states[ target ];
					if ( newState ) transitionTo( newState );  
					break;
					
				case CANCEL:
					canceled = true;
					break;
			}
		}
		
		/**
		 * Get the current state.
		 *  
		 * @return a State defining the machine's current state
		 */
		protected function get currentState():State
		{
			return viewComponent as State;
		}
		
		/**
		 * Set the current state.
		 */
		protected function set currentState( state:State ):void
		{
			viewComponent = state;
		}
		
		/**
		 * Map of States objects by name.
		 */
		protected var states:Object = new Object();
		
		/**
		 * The initial state of the FSM.
		 */
		protected var initial:State;
		
		/**
		 * The transition has been canceled.
		 */
		protected var canceled:Boolean;

	}
}