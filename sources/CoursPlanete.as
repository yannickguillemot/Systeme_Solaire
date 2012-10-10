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

	public class CoursPlanete extends Sprite {

		private var compteur:int=0;

		private var canvas:Sprite;
		private var btn_prev:prevButton;
		private var btn_next:nextButton;
		private var conteneur:MovieClip;

		private var barreProgression:progressBar;

		private var xml:XML;
		private var nom:Texte;
		private var contenu:Texte;

		private var fontTitle:Font = new titleFont();
		private var fontContent:Font = new contentFont();
		private var planetes:Array = new Array();


		//Constructeur de la classe
		public function CoursPlanete() {

			canvas = new Sprite();
			this.addChild(canvas);
			conteneur= new MovieClip();
			canvas.addChild(conteneur);

			//Création des boutons de navigation
			btn_prev = new prevButton();
			btn_next = new nextButton();
			btn_prev.x=1024/2-60;
			btn_next.x=1024/2+60;
			btn_prev.y=btn_next.y=600;
			canvas.addChild(btn_prev);
			canvas.addChild(btn_next);

			//Ajout de la barre de progression
			barreProgression = new progressBar();
			barreProgression.x=100;
			barreProgression.y=350;
			barreProgression.visible=false;
			canvas.addChild(barreProgression);

			// Chargement du fichier xml 
			var chargeur:URLLoader = new URLLoader();
			var adresse:URLRequest=new URLRequest("../xml/solar_system.xml");
			chargeur.addEventListener(Event.COMPLETE, XMLLoaded);
			chargeur.addEventListener(IOErrorEvent.IO_ERROR, errorDisplay);
			chargeur.load(adresse);

			// Ajout des events
			btn_prev.addEventListener(MouseEvent.MOUSE_DOWN, chargerPrecedent);
			btn_next.addEventListener(MouseEvent.MOUSE_DOWN, chargerSuivant);

			//Masquer le bouton 'précédent' si on est sur la première slide
			if (compteur==0) {
				btn_prev.visible=false;
			}


		}

		//Fonction appelée à l'issue du chargement du fichier XML
		public function XMLLoaded( event:Event ) {

			xml=new XML(event.target.data);
			
			/* On va stocker chaque loader dans un tableau pour accéder facilement à tous les swf 
			et les charger qu'une seule fois */
			for (var i=0; i<xml.children().length(); i++) {
				planetes[i] = new Loader();
				planetes[i].load(new URLRequest(xml.planet[i].attribute("swf")));
				planetes[i].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
				planetes[i].contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
				planetes[i].contentLoaderInfo.addEventListener(Event.UNLOAD, swfDecharge);
				planetes[i].x=60;
				planetes[i].y=150;
				planetes[i].visible = false;
				conteneur.addChild(planetes[i]);
			}
			
			planetes[compteur].visible = true;

			// Ajout du titre
			nom = new Texte((1024/2)+50, 120, 180, 50, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte( xml.planet[compteur].attribute("nom"));
			canvas.addChild(nom);
			
			// Ajout de la description
			contenu = new Texte((1024/2)-100, 170, 500, 400, 14, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte(xml.planet[compteur]);
			canvas.addChild(contenu);

		}
		
		//Fonction appelée pendant le chargement des swf. Affiche la barre de chargement
		function loading(e:ProgressEvent):void {
			barreProgression.visible=true;
			barreProgression.scaleX=e.bytesLoaded/e.bytesTotal;
		}

		//Fonction appelée une fois le chargement des swf effectué. Masque la barre de chargement
		function loaded(event:Event):void {
			barreProgression.visible=false;
		}

		function swfDecharge(event:Event):void {
			event.target.loaderInfo.removeEventListener(Event.UNLOAD, swfDecharge);
		}

		//Handler après clic précédent
		function chargerPrecedent(event:MouseEvent) {
			compteur--;
			if (compteur==0) {
				btn_prev.visible=false;
			} else {
				btn_next.visible=true;

			}
			planetes[compteur].visible = true;
			planetes[compteur+1].visible = false;
			//Enlève les précédents éléments
			canvas.removeChild(nom);
			canvas.removeChild(contenu);

			// Ajout du titre
			nom = new Texte((1024/2)+50, 120, 180, 50, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte( xml.planet[compteur].attribute("nom"));
			canvas.addChild(nom);
			
			// Ajout de la description
			contenu = new Texte((1024/2)-100, 170, 500, 400, 14, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte(xml.planet[compteur]);
			canvas.addChild(contenu);
		}

		//Handler après clic suivant
		function chargerSuivant(event:MouseEvent) {
			compteur++;
			if ((compteur+1) == xml.children().length()) {
				btn_next.visible=false;
			} else {
				btn_prev.visible=true;

			}
			planetes[compteur].visible = true;
			planetes[compteur-1].visible = false;
			//Enlève les précédents éléments
			canvas.removeChild(nom);
			canvas.removeChild(contenu);

			// Ajout du titre
			nom = new Texte((1024/2)+50, 120, 180, 50, 36, 0xFF6600, fontTitle.fontName);
			nom.Modifier_Texte( xml.planet[compteur].attribute("nom"));
			canvas.addChild(nom);
			
			// Ajout de la description
			contenu = new Texte((1024/2)-100, 170, 500, 400, 14, 0xCCCCCC, fontContent.fontName);
			contenu.Modifier_HtmlTexte(xml.planet[compteur]);
			canvas.addChild(contenu);
		}

		//Fonction de retour sur erreur
		function errorDisplay( event:Event ) {
			trace(event);
		}

	}
}