/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package
{
   import flash.display.*;
   import flash.net.*;
   import flash.utils.*;
 
   import flash.events.*;
   import flash.ui.*;
   import sandy.core.Scene3D;
   import sandy.core.data.*;
   import sandy.core.scenegraph.*;
   import sandy.materials.*;
   import sandy.materials.attributes.*;
   import sandy.primitive.*;
   import sandy.util.*;
   import sandy.events.*;
   import flashx.textLayout.formats.BackgroundColor;

   public class SolarSystem extends Sprite 
   {
      private var scene:Scene3D;
	  private var camera:Camera3D;
	  private var s:Sprite2D;
	  
	  //Création des différents éléments pour bouger les planètes
	  private var sun:TransformGroup;
	  private var mercury:TransformGroup;
	  private var venus:TransformGroup;
	  private var earth:TransformGroup;
	  private var mars:TransformGroup;
	  private var jupiter:TransformGroup;
	  private var saturn:TransformGroup;
	  private var uranus:TransformGroup;
	  private var neptune:TransformGroup;
	  private var tg:TransformGroup;
	  private var g:Group;

	  private var spaceLoader:Loader;
	  private var xml:XML = new XML();
	  private var _chargeur:Loader;
	  	  
	  private var canvas:Sprite;
	  private var conteneur:MovieClip;
	  private var back:background = new background();
	  
	  //Panneau d'informations
	  private var infoIcon:info = new info();
	  private var infos:infoKeys = new infoKeys();
	   
	  private var bitmap:Bitmap;
	  private var textureOrbite:BitmapData = new BitmapData( 200, 200, false, 0xFFFFFF );
	  
	  private var imgSun:sunImg = new sunImg();
	  
	  private var compteur:int = 0;
	  private var queue:LoaderQueue;
	  
	  public var x_center:Number = 1024/2;
	  public var y_center:Number = 768/2;
	  
	  private var coef:int = 1;
	  

	 //chargement des .swf
	 public function SolarSystem():void
     {	
	 	queue = new LoaderQueue();
       	queue.add( "sun", new URLRequest("../images/Sun.png") );
	   	queue.addEventListener(SandyEvent.QUEUE_COMPLETE, loadComplete );
       	queue.start();
	 }
	 
	 private function loadComplete(event:QueueEvent){
		
		canvas = new Sprite();
		this.addChild(canvas);
		
		//Création du groupe qui sera le réceptacle de les éléments de la scène
        var root:Group = createScene();
		camera = new Camera3D( 1024, 768 );
		camera.y = 450; //monte la caméra vers le haut
		camera.z = -470; //dézoom
		camera.lookAt(0,300,0);
		//Création de la scène
	    scene = new Scene3D( "scene", canvas, camera, root );
		scene.rectClipping = true;		 
		 
		//Affichage et rendu de la scène
        addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedHandler);
		//stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseHandler);
		
	 }
	
	//Fonction qui créé chaque élément de la scène.
	private function createScene():Group
      {	
	  	//Pour controler indépendamment chaque planète, on utilise un TransformGroup pour chaque planète
        g = new Group();
		sun = new TransformGroup();
		mercury = new TransformGroup();
		venus = new TransformGroup();
		earth = new TransformGroup();
		mars = new TransformGroup();
		jupiter = new TransformGroup();
		saturn = new TransformGroup();
		uranus = new TransformGroup();
		neptune = new TransformGroup();
		tg = new TransformGroup();
		
		// Chargement du fichier xml 
		var chargeurXML:URLLoader = new URLLoader();
		var adresseXML:URLRequest = new URLRequest("../xml/solar_system.xml");
		chargeurXML.addEventListener(Event.COMPLETE, XMLLoaded);
		chargeurXML.addEventListener(IOErrorEvent.IO_ERROR, errorDisplay);			
		chargeurXML.load(adresseXML);
		tg.addChild(sun)
		tg.addChild(mercury);
		tg.addChild(venus);
		tg.addChild(earth);
		tg.addChild(mars);
		tg.addChild(jupiter);
		tg.addChild(saturn);
		tg.addChild(uranus);
		tg.addChild(neptune);
		
		//Ajout de l'image 2D du soleil au centre du système solaire
		var bit:Bitmap = new Bitmap(queue.data["sun"].bitmapData);
		var s:Sprite2D = new Sprite2D("sun",bit,0.15);
		s.x = 0;
		s.y = 300;
		sun.addChild(s);
		
		canvas.addEventListener(MouseEvent.MOUSE_OVER, planeteOver);
		canvas.addEventListener(MouseEvent.MOUSE_OUT, planeteOut);
		g.addChild(tg);
		
		return g;
      }
	  
	  /*public function createSun():Sphere{
		var sphere:Sphere = new Sphere("sphere", 50,22,22); /* var sphere:Sphere = new Sphere ("mySphere", radius, quality, quality);
		 											  en qualité 25 suffit pour des tailles relativement grosses 
													  Par rapport à la taille originale de la texture, radius = 150 est environ 
													  la limite maxi avant de voir apparaitre des pixels sur le résultat 
		sphere.x = 0; 
		sphere.y = 300; //au centre de la caméra
		sphere.scaleX = 0.7;
		sphere.scaleY = 0.7;
		sphere.scaleZ = 0.7;
		 
		// Choix de la texture de la planète 
		var img: sunMap = new sunMap() ; 
		bitmap = new Bitmap(img);
				
	    var material:BitmapMaterial = new BitmapMaterial( bitmap.bitmapData );
		material.lightingEnable = true;
	    var app:Appearance = new Appearance( material );
		sphere.appearance = app;
		
		return sphere;
	  } */
	  
	  //Fonction appelée pour créer chaque planète
	  public function createPlanet(i:int):Sphere{
		
		var sphere:Sphere = new Sphere("sphere", 10,13,13); /* var sphere:Sphere = new Sphere ("mySphere", radius, quality, quality);
		 											  en qualité 50 suffit pour des tailles relativement grosses 
													  Par rapport à la taille originale de la texture, radius = 150 est environ 
													  la limite maxi avant de voir apparaitre des pixels sur le résultat */
		 sphere.x = 50 + 10 + xml.planet[i].attribute("distance")*(i*20); 
		 sphere.y = 300; //au centre de la caméra
		 sphere.scaleX = xml.planet[i].attribute("scale");
		 sphere.scaleY = xml.planet[i].attribute("scale");
		 sphere.scaleZ = xml.planet[i].attribute("scale");
		 
		 
		 // Choix de la texture de la planète
		 switch (i){
			case 0:
				var img0: mercuryMap = new mercuryMap() ;
				bitmap = new Bitmap(img0);
				break;
			case 1:
				var img1: venusMap = new venusMap() ;
				bitmap = new Bitmap(img1);
				break;
			case 2:
				var img2: earthMap = new earthMap() ;
				bitmap = new Bitmap(img2);
				break;
			case 3:
				var img3: marsMap = new marsMap() ; 
				bitmap = new Bitmap(img3);
				break;
			case 4:
				var img4: jupiterMap = new jupiterMap() ; 
				bitmap = new Bitmap(img4);
				break;
			case 5:
				var img5: saturnMap = new saturnMap() ; 
				bitmap = new Bitmap(img5);
				break;
			case 6:
				var img6: uranusMap = new uranusMap() ; 
				bitmap = new Bitmap(img6);
				break;
			case 7:
				var img7: neptuneMap = new neptuneMap() ; 
				bitmap = new Bitmap(img7);
				break;
				
		}
		//Ajout de la texture
	     var material:BitmapMaterial = new BitmapMaterial( bitmap.bitmapData );
		 material.lightingEnable = true;
	     var app:Appearance = new Appearance( material );

		 sphere.appearance = app;
		 
		 return sphere;
	  } 
	 
	 //Fonction appelée après chargement du fichier XML
  	 public function XMLLoaded( event:Event ){
			
			if (event.target.data){
				xml = new XML(event.target.data);	
			}
			
			
			for (var i = 0; i<xml.children().length(); i++) {// balise planet
		 		 switch (i){
			case 0:
				mercury.addChild( createPlanet(i) );				
				break;
			case 1:
				venus.addChild( createPlanet(i) );
				break;
			case 2:
				earth.addChild( createPlanet(i) );
				break;
			case 3:
				mars.addChild( createPlanet(i) );
				break;
			case 4:
				jupiter.addChild( createPlanet(i) );
				break;
			case 5:
				saturn.addChild( createPlanet(i) );
				break;
			case 6:
				uranus.addChild( createPlanet(i) );
				break;
			case 7:
				neptune.addChild( createPlanet(i) );
				break;}				
		 	}
			
			orbiteDesign();

	 } 
	  
	  //Fonction qui génère les orbites de toutes les planètes
	  public function orbiteDesign():void{
		 conteneur = new MovieClip();
		 for (var i = 0; i<xml.children().length(); i++) {
				
				var cercle:Torus = new Torus("orbite", 50 + 10 + xml.planet[i].attribute("distance")*(i*20), 0.2, 25, 2);

				// Positionnement et affichage du cercle dans la séquence
				cercle.useSingleContainer = false;
				cercle.enableBackFaceCulling = true;
				cercle.enableNearClipping = true; 
				cercle.x = 0;
				cercle.y = 300;
				var material:Material = new ColorMaterial( 0xFFFFFF);
				cercle.appearance = new Appearance( material);/
				
				tg.addChild(cercle);
			
			} 
	  } 
	  
	  //Si on survole une planète, on arrête la rotation des éléments du système
	  private function planeteOver(event:Event):void{
		  back.visible = true;
		  coef = 0;
	  }
	  
	   private function planeteOut(event:Event):void{
		  back.visible = false;
		  coef = 1;
	  }

      //Rendu de la scène
      private function enterFrameHandler( event : Event ) : void
      {
		scene.render();
		var vitesse_rotation:int = 2;
		//On fait bouger chaque planète sur son orbite suivant une vitesse définie
		mercury.pan += coef*3.5 /vitesse_rotation;
		venus.pan += coef*2.3 /vitesse_rotation;
		earth.pan += coef*1.7 /vitesse_rotation;
		mars.pan += coef*1.4 /vitesse_rotation;
		jupiter.pan += coef*1 /vitesse_rotation;
		saturn.pan += coef*0.7 /vitesse_rotation;
		uranus.pan += coef*0.5 /vitesse_rotation;
		neptune.pan += coef*0.3 /vitesse_rotation; 
      } 
	  
	  //Fonction de retour sur erreur
		function errorDisplay( event:Event ) {
			trace(event);
		}
		
	  //Fonctions handlers pour le panneau d'informations
	  function infoHandlerOver (event:Event){
		  infos.visible = true;
		  infoIcon.visible = false;
	  }
	  
	  function infoHandlerOut (event:Event){
		  infos.visible = false;
		  infoIcon.visible = true;
	  }
	  
	  
	  //Fonction non utilisée. Permettrai de controler les mouvements de la scène au clavier
	  private function keyPressedHandler(event:KeyboardEvent):void {
		  coef = 0;
			switch(event.keyCode) {
				case Keyboard.UP:
					tg.tilt +=6;
					break;
				case Keyboard.DOWN:
					tg.tilt -=6;
					break;
				case Keyboard.LEFT:
					camera.x -=6;
					break;
				case Keyboard.RIGHT:
					camera.x +=6;
					break;}
			coef = 1;
						
				
        }
		
		//Fonction non utilisée. Permettrai de controler le zoom de la scène avec la molette de la souris
	  	function mouseHandler(event:MouseEvent):void {
			coef = 0;
		 	camera.z -= 3*event.delta;  
			coef = 1;
        }
		
   }
}