/* Projet IN42 : Introduction au multimédia. 
Réalisé par Guillemot Yannick et Grosperrin Quentin
Printemps 2011 */
package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.system.fscommand;
	import flash.text.Font;
	import flash.display.DisplayObject;
	
	//Importation de la classe Texte qui nous permet de facilement générer du texte
	import Texte;
	import sandy.primitive.SkyBox;

	
	public class MenuPrincipal extends Sprite {
		
		var conteneur:MovieClip;
		var menu:MovieClip;
		var header:header_mc=new header_mc();
		var menu_btn: btn_menu = new btn_menu();
		var btn_sub:btn_submenu;
		
		var menuDown:Boolean = false;
		
		var monTween:Tween;
		
		//Variables relatives au xml
		var arrayNomMenu:Array;
		var arraySousMenus:Array;
		var arrayNiveau:Array;
		var arraySwf:Array;
		var arrayDesc:Array;
		
		//Variables relatives aux polices
		var font:Font = new xirod();
		var subfont:Font = new subPolice();
		var formatTitre:TextFormat = new TextFormat(); 
		var texte:TextField = new TextField();	
		
		var title_btn:Texte;
		
		var papa:Main;
		var xml:XML;
		var bool:Boolean = true;
		var chargeurSwf:Loader;
		
		// Musique de fond
		var requete:URLRequest = new URLRequest ("../sons/cosmotologie.mp3");
		var musique:Sound = new Sound (requete); // Chargement progressif
		// Objet permettant de contrôler le son
		var musique_fond:SoundChannel = new SoundChannel();
		// création du conteneur du son
		var son_ouvre:Sound = new Sound();
		var son_ferme:Sound = new Sound();
		var son_menu:Sound = new Sound();
		// url du fichier mp3
		var son_ouvreMP3:URLRequest = new URLRequest("../sons/overSubMenu.mp3");
		var son_fermeMP3:URLRequest = new URLRequest("../sons/outSubMenu.mp3");
		var son_menuMP3:URLRequest = new URLRequest("../sons/clicMenu.mp3");
		// Objet permettant de contrôler le son
		var canal:SoundChannel = new SoundChannel();
		
		
		// Variable du plein écran
		var fullscreen:Boolean = false;
		// Variable partagé avec le reste de l'application (cookie)
		var share:SharedObject = SharedObject.getLocal("monCookie", "/");
		
		public function MenuPrincipal(papa:Main) {
			
			//Chargement musique de fond et autres sons
			share.data.sonOn = true;	
			musique_fond = musique.play ();
			son_ouvre.load(son_ouvreMP3);
			son_ferme.load(son_fermeMP3);
			son_menu.load(son_menuMP3);
			
			// Liste des menu, sous menu et des swf associés
			arrayNomMenu = new Array();
			arraySousMenus = new Array();
			arrayNiveau = new Array();
			arraySwf = new Array();
			arrayDesc = new Array();
			
			this.papa = papa;
			
			/*Style utilisé pour le texte Alternatif*/
   			var formatTitre:TextFormat = new TextFormat();  
    		formatTitre.color = 0xFF6600;  
    		formatTitre.size = 20;  
    		formatTitre.font = font.fontName; 
			
			// Définir d'un conteneur
			conteneur = new MovieClip();
			this.addChild(conteneur);
			conteneur.x=0;
			
			//Ajout de la barre sur la barre de menu
			menu = new MovieClip();
			conteneur.addChild(menu);
			
			//Ajout du bouton en forme de Soleil pour afficher la barre de menu
			menu_btn.x = 17;
			menu_btn.y = -72;
			menu_btn.addEventListener(MouseEvent.MOUSE_DOWN, menuClick);
			menu_btn.addEventListener(MouseEvent.MOUSE_OVER, overMenu);
			menu_btn.addEventListener(MouseEvent.MOUSE_OUT, outMenu);
			menu.addChild(menu_btn);
			//Ajout du texte sur le soleil
			title_btn = new Texte(62, 8, 180, 50, 26, 0x000000, font.fontName);
			title_btn.Modifier_Texte("Menu");
			title_btn.visible = false;
			title_btn.addEventListener(MouseEvent.MOUSE_DOWN, menuClick);
			title_btn.addEventListener(MouseEvent.MOUSE_OVER, overMenu);
			title_btn.addEventListener(MouseEvent.MOUSE_OUT, outMenu);
			menu.addChild(title_btn);
						
			header.x = 0;
			header.y = -53;
			menu.addChild(header);
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
						
			// Bouton permettant d'activer ou désactiver le son
			var btn_son: btn_volume = new btn_volume();
			btn_son.x = 920;
			btn_son.y = -42;
			btn_son.addEventListener(MouseEvent.MOUSE_DOWN, sound);
			menu.addChild(btn_son);
			
			// Bouton permettant de passer ou de quitter le mode plein écran
			var btn_screen: btn_fenetre = new btn_fenetre();
			btn_screen.x = 970;
			btn_screen.y = -42;
			btn_screen.addEventListener(MouseEvent.MOUSE_DOWN, screen);
			menu.addChild(btn_screen);
			
			// Chargement du fichier xml 
			var chargeur:URLLoader = new URLLoader();
			var adresse:URLRequest=new URLRequest("../xml/menu.xml");
	
			chargeur.addEventListener(Event.COMPLETE, XMLLoaded);
			chargeur.addEventListener(IOErrorEvent.IO_ERROR, errorDisplay);			
			chargeur.load(adresse);
				
				
			}
		
		//Ajoute l'animation d'accueil
		function added(event:Event){
			chargeurSwf = new Loader();
			chargeurSwf.load(new URLRequest("../publications/solarSystem.swf"));
			chargeurSwf.contentLoaderInfo.addEventListener(Event.UNLOAD,swfDecharge);
			this.addChild(chargeurSwf);
			//papa.changer("../publications/solarSystem.swf");
		}
		
		// Activation ou désactivation du son
		function sound(e:MouseEvent):void {
			if(share.data.sonOn){
				share.data.sonOn = false;
				musique_fond.stop ();
				}
			else {
				share.data.sonOn = true;
				musique_fond = musique.play ();}
		}
		
		// Passage en plein écran ou en mode fenetré
		function screen(e:MouseEvent):void {
			if (fullscreen) 
			{
				fscommand("fullscreen", "false");
				fullscreen = false;
			}
			else
			{
				fscommand("fullscreen", "true");
				fullscreen = true;
			}
		}
		
		//Fonction appelée à l'issue du chargement du fichier XML
		public function XMLLoaded( event:Event ){
			
			xml =new XML(event.target.data);	
			
			var ecartX = 180 + 10; //180 = largeur liste déroulante. 10 = espacement entre les listes déroulantes
			
			// Création des onglets du menu et des sous menu qui les composent
			for (var i = 0; i<xml.children().length(); i++) {// balise menu
					
				//Ajout des menus
				var menuCombo:MovieClip;
				menuCombo = new submenu();
				menuCombo.x = 150 + i * ecartX;
				menuCombo.y = -232;
				
				// ajout nom du menu
				var nom:Texte = new Texte(40, 185, 140, 23, 20, 0x000000, font.fontName);
				nom.Modifier_Texte(xml.menu[i].attribute("nom"));
				menuCombo.addChild(nom);
				
				arrayNomMenu.push( xml.menu[i].attribute("nom") );
			
				// listeners et affichage
				menuCombo.addEventListener(MouseEvent.ROLL_OVER,menuOver);
				menuCombo.addEventListener(MouseEvent.ROLL_OUT,menuOut);
				menu.addChild(menuCombo);
				
				arraySousMenus.push( new Array() );
				arrayNiveau.push ( new Array() );
				arraySwf.push( new Array());
				arrayDesc.push( new Array());
				
				for (var j = 0; j<xml.menu[i].children().length(); j++) {// balise submenu
					
					//Ajout des boutons de sous-menus permettant le chargement des swf de l'application
					btn_sub= new btn_submenu();
					btn_sub.x = 15;
					btn_sub.y = (155 - xml.menu[i].children().length()* 25+ j*25);
					btn_sub.name = xml.menu[i].submenu[j].attribute("nom");
					btn_sub.addEventListener(MouseEvent.MOUSE_DOWN, loadSWF);
					menuCombo.addChild(btn_sub);
					
					//Ajout du texte sur les sous-menus
					var subnom:Texte = new Texte( 7,  3, 140, 30, 17, 0xFF9900, subfont.fontName);
					subnom.Modifier_Texte(xml.menu[i].submenu[j].attribute("nom"));
					btn_sub.upState = subnom;
					var subnomOver:Texte = new Texte( 7,  3, 140, 30, 17, 0x000000, subfont.fontName);
					subnomOver.Modifier_Texte(xml.menu[i].submenu[j].attribute("nom"));
					btn_sub.overState = subnomOver;
					
					
					arraySousMenus[ arraySousMenus.length - 1 ].push( btn_sub.name );
					arrayNiveau[ arrayNiveau.length - 1 ].push(j+1);
					
					arraySwf[arraySwf.length - 1].push(xml.menu[i].submenu[j].attribute("swf"));
					arrayDesc[arrayDesc.length - 1].push(xml.menu[i].submenu[j].attribute("description")); 
					
				}
				
			}

		}
		
		//Fonction appelée par clic sur un sous-menus. On charge alors le swf correspondant
		function loadSWF (event:MouseEvent){
			var continu:Boolean = true;
			if (share.data.sonOn) {
				canal.stop();
				canal = son_menu.play();
			}
			if (bool){
				chargeurSwf.unload();
				chargeurSwf = null;
				bool = false;}
				
			//On localise dans le tableau le bon swf qui doit être chargé
			for (var i = 0; i<arraySousMenus.length && continu; i++) {
				for (var j = 0; j<arraySousMenus[i].length && continu; j++) {
						if ( event.target.name == arraySousMenus[i][j] ) {
							//Appel de la fonction changer de la classe Main.as pour charger le swf passé en paramètre
							papa.changer(arraySwf[i][j], arrayDesc[i][j]);
							continu = false;
							monTween=new Tween(menu,"y",Regular.easeOut,48,0,0.5,true);
							menuDown = false;
					}
					
				}
			}

		}
		
		function swfDecharge(event:Event):void {
			//event.target.loaderInfo.removeEventListener(Event.UNLOAD, swfDecharge);
		}
			
		//Code Pour le tween
		function menuClick (e:MouseEvent){
			if (share.data.sonOn) {
				canal.stop();
				canal = son_menu.play();
			}
			if(menuDown){
				monTween=new Tween(menu,"y",Regular.easeOut,48,0,1,true);
				menuDown = false;}
			else{
				monTween=new Tween(menu,"y",Regular.easeOut,0,48,1,true);
				menuDown = true;}
		}
		
		function menuOver (e:MouseEvent){
			// Lecture du son et stockage dans le canal
			if (share.data.sonOn) {
				canal.stop();
				canal = son_ouvre.play();
			}
			if(menuDown)
				monTween=new Tween(e.target,"y",Regular.easeOut,-232,-80,0.7,true);
		}
		
		function menuOut (e:MouseEvent){
			if (share.data.sonOn) {
				canal.stop();
				canal = son_ferme.play();
			}
			monTween=new Tween(e.target,"y",Regular.easeOut,-80,-232,1,true);
		}
		
		//Fonction de retour sur erreur
		function errorDisplay( event:Event ) {
			trace(event);
		}
		
		// Mise en évidence du texte menu
		function overMenu(event:MouseEvent):void {
			title_btn.visible = true;
		}
		
		
		function outMenu(event:MouseEvent):void {
			title_btn.visible = false;
		}
		
		
		
	}
}