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
	
	import Texte;
	
	import MenuPrincipal;
	
	public class Main extends MovieClip {

		
		
		// Conteneur principal
		private var m_cible:MovieClip;

		var MenuP:MenuPrincipal;
		var conteneurPartie:Sprite = new Sprite();
		
		var chargeurSwf:Loader=new Loader();
		
		var back:fond;
		var backTexte:Texte;
		var panneau:panneauInfo;
		var subfont:Font = new subPolice();
		var texteDesc:Texte;
		
		public function Main(cible:MovieClip):void {
					
				
				
				// Initialisation du main
				MenuP=new MenuPrincipal(this);
				
				m_cible=cible;
				
				//On ajoute le fond étoilé en arrière-plan
				var stars:sky = new sky();
				stars.x = 0;
				stars.y = 0;
				m_cible.addChildAt(stars,0);
				
				//Ajout du texte de bienvenue
				backTexte = new Texte(512-400, 70, 800, 300, 17, 0xFFFFFF, subfont.fontName);
				backTexte.Modifier_HtmlTexte("Bienvenue dans l’espace !" + 
											"<br>Vous êtes sur le point de voyager dans le système solaire." +
											"<br>Mettez vos sens en alerte, et lancez-vous dans un apprentissage haut en couleurs." +
											"<br><br>Utilisez le menu pour naviguer parmi l’application." +
											"<br>Commencez par apprendre, exercez-vous puis testez vos connaissances !" +
											"<br><br><b>Bon voyage<b>");
				var T_Format:TextFormat = new TextFormat();
				T_Format.align = "center";
				backTexte.setTextFormat(T_Format);
				backTexte.defaultTextFormat = T_Format;
				stars.addChild(backTexte);
				
				//Ajout d'un fond semi-transparent blanc pour faciliter la lecture et la visibilité des swf
				back = new fond();
				back.x = 20;
				back.y = 15;
				back.alpha = 0.2;
				back.visible = false;
				m_cible.addChildAt(back, 1);
				
				/*Ajout d'une panneau en bas au centre de l'écran pour indiquer à l'utilisateur comment procéder avec 
				ce qu'il voit à l'écran. Chaque description peut être modifié dans le fichier 'menu.xml' */
				panneau = new panneauInfo();
				panneau.x = 1024/2 - 540/2;
				panneau.y = 768 - 62;
				panneau.visible = false;
				texteDesc = new Texte(30, 15, 450, 50, 16, 0x000000, subfont.fontName);
				panneau.addChild(texteDesc);
				
				//Pour éviter les superpositions, on fait attention à bien régler la profondeur de chaque élément
				m_cible.addChildAt(conteneurPartie,2);
				m_cible.addChildAt(panneau,3);
				m_cible.addChildAt(MenuP,4);
				
				
	
				
			}
			
		// Fonction qui vide le conteneur de swf
		function viderConteneurPartie(){
			if (conteneurPartie.numChildren>0) {
				for (var k:uint = 0; k < conteneurPartie.numChildren + 1; k++) {
					conteneurPartie.removeChildAt(0);
				}
			}
		}
			
		// Fonction qui charge le swf donné en paramètre et affiche la description s'il y en a une
		public function changer(swf:String, desc:String) {
			viderConteneurPartie();
			chargeurSwf.unloadAndStop();
			chargeurSwf.load(new URLRequest(swf));
			if (swf == "../publications/jeu.swf"){
				chargeurSwf.x = 1024/2 - 540/2;
				chargeurSwf.y = 768/2 - 200;
			}
			else {
				chargeurSwf.x = 0;
				chargeurSwf.y = 0;
			}
			conteneurPartie.addChild(chargeurSwf);
			back.visible = true;
			backTexte.visible = false;
			
			//Ajout de la description
			if (desc != ""){
				back.alpha = 0.2;
				panneau.visible = true;
				texteDesc.Modifier_Texte(desc);
			}
			else {
				back.alpha = 0.4;
				panneau.visible = false;
			}
			

		}
		
	}
		
}