/*
	PureMVC Utility - Loadup
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.loadup.assetloader.model.assets
{
	import mx.controls.Image;
	import mx.core.UIComponent;

	import org.puremvc.as3.multicore.utilities.loadup.Loadup;
	import org.puremvc.as3.multicore.utilities.loadup.assetloader.interfaces.IAssetForFlex;

	public class AssetOfTypeImage extends AssetBase implements IAssetForFlex
	{
        private var _uiComponent :UIComponent;

		public function AssetOfTypeImage( url :String ) {
		    super( url );
		}

		public function get type() :String {
		    return Loadup.IMAGE_ASSET_TYPE;
		}
		public function get uiComponent() :UIComponent {
		    if ( ! data )
		        return null;
		    if ( ! _uiComponent ) {
		        var img :Image = new Image();
		        img.load( data);
		        _uiComponent = img;
		    }
		    return _uiComponent;
		}

	}
}