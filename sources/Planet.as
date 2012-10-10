/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
 
   import flash.events.*;
   import flash.ui.*;
   import sandy.core.Scene3D;
   import sandy.core.data.*;
   import sandy.core.scenegraph.*;
   import sandy.materials.*;
   import sandy.materials.attributes.*;
   import sandy.primitive.*;
   import sandy.events.*; 
   import flash.text.engine.SpaceJustifier;
   import flash.display.MovieClip;

   public class Planet extends MovieClip
   {
      private var scene:Scene3D;
	  private var camera:Camera3D;
	  private var sphere:Sphere;
	  private var app:Appearance;
	  
	  //variable permettant de créer la texture sur la sphère
	  private var img:neptuneMap = new neptuneMap(); //A remplacer par la texture correpondante
	  private var bitmap:Bitmap=new Bitmap(img);
	  
	  private var conteneur:MovieClip = new MovieClip();

      public function Planet()
      { 
	  	 this.addChild(conteneur);
		 var canvas:Sprite = new Sprite();
		 conteneur.addChild(canvas);
		 //Création de la caméra de la scène
		 camera = new Camera3D( 300, 300 );
		 camera.z = -400; // Dézoom un peu
		 
		 //Création du groupe qui sera le réceptacle de les éléments de la scène
         var root:Group = createScene();
		//Création de la scène
	     scene = new Scene3D( "scene_planet", canvas, camera, root );
		 
		 //Affiche et génère un rendu de la scène
         addEventListener( Event.ENTER_FRAME, enterFrameHandler ); 
      }

      //Fonction appelée pour la création de la scène
      private function createScene():Group
      {
         //Création du Group
         var g:Group = new Group();

		 sphere = new Sphere("sphere", 150,19,19); /* var sphere:Sphere = new Sphere ("mySphere", radius, quality, quality);
		 											  en qualité 20 suffit pour des tailles relativement grosses 
													  Par rapport à la taille originale de la texture, radius = 150 est environ 
													  la limite maxi avant de voir apparaitre des pixels sur le résultat */
		 sphere.x = 0;
		 sphere.y = 0;
		 
		 //Définition de la texture	 
	     var material:BitmapMaterial = new BitmapMaterial( bitmap.bitmapData );
		 material.lightingEnable = true;
	     app = new Appearance( material );


		 sphere.appearance = app;
	
		 g.addChild( sphere );
          
		 return g;
      }

      //Rendu de la scène avec rotation progressive de la sphère
      private function enterFrameHandler( event : Event ) : void
      {

		 sphere.pan += 0.5;
		 scene.render();
      }
	  
	  
   }
}